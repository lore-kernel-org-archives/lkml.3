Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256Ab3BGRu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:50:27 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:53109 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759200Ab3BGRu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:50:26 -0500
Date: Thu, 7 Feb 2013 17:50:18 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/49] ARM: ux500: Update displays in vaux1 consumer list
Message-ID: <20130207175018.GC7519@gmail.com>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
 <1360148051-7560-10-git-send-email-lee.jones@linaro.org>
 <CACRpkda=HMwnip8EziZewMPmRb19gc9E1_vJHtAUJ+UjFJ6byQ@mail.gmail.com>
 <20130207155504.GX4720@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130207155504.GX4720@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2013, Mark Brown wrote:

> On Thu, Feb 07, 2013 at 04:34:18PM +0100, Linus Walleij wrote:
> > On Wed, Feb 6, 2013 at 11:53 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > > Add 3 more specific consumers pertaining to the displays found
> > > on the u8500 and ST User Interface Boards (UIBs).
> 
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> > This look correct,
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> > Do you want me to merge the ux500 portions into the ux500
> > maintenance tree?
> 
> Lee indicated that splitting them up from the regulator changes causes
> bisection issues.

Right.

Ideally just Acks would be really good Linus.

Would you be happy with that?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
