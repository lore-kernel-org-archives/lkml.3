Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab3EFXuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:50:01 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:58057 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843Ab3EFW5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:57:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130506.170537.2116026617074159336.davem@davemloft.net>
References: <20130506.170537.2116026617074159336.davem@davemloft.net>
Date: Mon, 6 May 2013 15:57:15 -0700
X-Google-Sender-Auth: 4F2DzWLaHPmL5fj6W7k5PZKTqhc
Message-ID: <CA+55aFzQ8MzrmPQNPfLFA3nVQVDR3HL+RwcGrAwanJCKRxL2=A@mail.gmail.com>
Subject: Re: [GIT] Networking
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 2:05 PM, David Miller <davem@davemloft.net> wrote:
>
> Just a small pile of fixes:

Ok, apparently the e1000e problem didn't get fixed yet. Should I just
revert ce43a2168c59 for now, or do we have a fix for that forthcoming
shortly?

             Linus
