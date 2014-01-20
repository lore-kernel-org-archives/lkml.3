Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaATQwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:52:50 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:62630 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbaATQws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:52:48 -0500
Message-ID: <1390236763.25903.12.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
From: Sergei Ianovich <ynvich@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Date: Mon, 20 Jan 2014 20:52:43 +0400
In-Reply-To: <52DD4CDE.7020705@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
		 <201312182210.30544.arnd@arndb.de>
		 <1387401646.31516.14.camel@host5.omatika.ru>
		 <201312190630.11087.arnd@arndb.de>
		 <1389309176.32346.1.camel@host5.omatika.ru>
	 <1390234117.25903.0.camel@host5.omatika.ru> <52DD4CDE.7020705@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-20 at 17:20 +0100, Daniel Mack wrote:
> On 01/20/2014 05:08 PM, Sergei Ianovich wrote:
> > It's over a month now. Is anything wrong?
> No, I'm busy, that's all.

Thanks for reply.

> That said, the current situation is
> 
> a) we need someone to have a look at the performance regression of the
> MMC file system layer that you reported. I couldn't find a PXA-based
> board yet with a MMC slot soldered on it. But as you apparently have
> such hardware, I'd really appreciate your help here. Could you do some
> measurements and see whether you see major differences in packet size or
> timings?

I have the hardware with MMC, but none of the other devices. Could you
give some pointer where to start? How would you do measurements?

(...)

> So please, if you have any spare time, have a look at the MMC
> regressions and see if you can contribute anything. I'll hope to find
> some time to rebase my patches on top of 3.13 very soon, so we have a
> new base to work on.

It would be nice to have updated patches. Most interesting is whether
the new DMA still works as expected for other devices.

Apart from that, would mind if my series is landed with a workaround
(Patch v3 7/21). I hope you understand it doesn't feel good to depend on
something with no development activity.

