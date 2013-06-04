Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab3FDVQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:16:47 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:54035 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3FDVQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:16:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130604204801.GA1168@polaris.bitmath.org>
References: <1341469873-1582-1-git-send-email-rydberg@euromail.se>
	<20130604204801.GA1168@polaris.bitmath.org>
Date: Tue, 4 Jun 2013 17:16:45 -0400
X-Google-Sender-Auth: JCEZkSxevsQgHhMk-vy2XG2X9Lo
Message-ID: <CAKb7UvhizpvM5FQNcdq=zFN0cTgTT=_saj_gX9EMt=ND8Oibcw@mail.gmail.com>
Subject: Re: [REGRESSION] nouveau: Resume hung after protecting against client
 races (MBA3,1)
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dave Airlie <airlied@redhat.com>, nouveau@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 4:48 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Ben,
>
> The new mutexes in nvc0/nv50 (fadb17190/b509656) break resume on my
> MBA3,1. A dead-lock somewhere, perhaps? Reverting fixes the problem.

A bunch of people saw it earlier. Fixed for nv50 (which is what I
assume you have) in
http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=e9de89adcecb7a1296f5bc4d0052f58e18edd0a8

I assume it's on its way to mainline.

  -ilia
