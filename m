Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab3LJEZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 23:25:31 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:38685 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3LJEZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 23:25:27 -0500
Message-ID: <1386649521.7152.196.camel@host5.omatika.ru>
Subject: Re: [PATCH 5/9] ARM: dts: provide DMA config to pxamci
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Mack <zonque@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        DOCUMENTATION <linux-doc@vger.kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Date: Tue, 10 Dec 2013 08:25:21 +0400
In-Reply-To: <201312100125.18754.arnd@arndb.de>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com>
	 <52A59991.1060305@gmail.com> <1386590958.7152.135.camel@host5.omatika.ru>
	 <201312100125.18754.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 01:25 +0100, Arnd Bergmann wrote:
> We never intentionally break things that people are using, but there are
> cases where doing blind changes is the best way forward. We should
> always try to find people to test patches on real hardware if possible,
> which is only possible if there are people around that have the hardware
> and that are going to run new kernels on them.
> 
> In case of PXA dmaengine support, I think the benefits of applying the
> series far outweigh the breakage potential. A lot of the drivers are
> shared with MMP, which is going to be DT-only eventually and will require
> the new dmaengine code. Some PXA drivers may be shared with SA1100,
> which has also converted to dmaengine although there are no plans to
> ever support DT on sa1100.
> 
> We certainly need to be extra careful if we want to move things over
> at once and cannot test all the drivers. I'd be happier if it could
> be done gradually by having some drivers use the new interface and
> other drivers use the old one, but I don't see how that can be done
> here.

Thanks for detailed explanation. I see there is strong support for the
big change. Lets hope it'll be smooth. I'll strest test Daniel's changes
and report the results.


