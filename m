Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3JYH76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 03:59:58 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:43184 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3JYH75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 03:59:57 -0400
MIME-Version: 1.0
In-Reply-To: <20131024132734.GB2634@kernel.dk>
References: <20131024132734.GB2634@kernel.dk>
Date: Fri, 25 Oct 2013 08:59:55 +0100
Message-ID: <CAPM=9tzThUmwO1Pw6PvtUvM7ywDzWGSF23wCEVS=wMa3PVNEPw@mail.gmail.com>
Subject: Re: 3.12-rc6 nouveau oops
From: Dave Airlie <airlied@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Dave Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Booting 3.12-rc6 on my macbook quickly freezes after logging in to X. I
> was able to capture this oops. It's 100% consistent. 3.11 works
> perfectly fine, as did previous kernels.

Can you boot with nouveau.runpm=0 and see if it boots and survives
suspend/resume.

Dave.
