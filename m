Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbbATTQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:16:50 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:38608 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbbATTQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:16:47 -0500
MIME-Version: 1.0
In-Reply-To: <1421780421.32504.2.camel@theros.lm.intel.com>
References: <20150120185308.53f4af4e@canb.auug.org.au>
	<20150120165655.GA10904@kria>
	<4237741.ePaG0Gba6D@sifl>
	<CAOMZO5ASd2Z20NOwZaQDneZ=35jyVUG-ggpaxo4v8VSds7yuoA@mail.gmail.com>
	<1421780421.32504.2.camel@theros.lm.intel.com>
Date: Tue, 20 Jan 2015 17:16:45 -0200
Message-ID: <CAOMZO5A0fjtzX+Gp8pWz=NawY1qEKK10BEgb7BMxTi_634qFYA@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
From: Fabio Estevam <festevam@gmail.com>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Boaz Harrosh <openosd@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Paul Moore <pmoore@redhat.com>, Sabrina Dubroca <sd@queasysnail.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-audit@redhat.com,
        viro@zeniv.linux.org.uk, Richard Guy Briggs <rgb@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 5:00 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:

> These were just nuisance warnings, I believe, so my guess is that this
> isn't related to your kernel panic.   Reverting Boaz's patches to make
> these warnings go away would let you know for sure.

You are right. Reverting 937af5ecd0591e makes such warnings disappear.
