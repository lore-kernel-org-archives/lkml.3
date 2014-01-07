Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbaAGOog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:44:36 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:45839 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaAGOo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:44:27 -0500
Date: Tue, 7 Jan 2014 14:44:21 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 01/11] ARM: ux500: Don't use enums for MSP IDs - for easy
 DT conversion
Message-ID: <20140107144421.GJ3182@lee--X1>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
 <1387468508-12286-2-git-send-email-lee.jones@linaro.org>
 <CACRpkda5bQ37OCtO17hj_tVrkAdTXA4-DzgBTaFmuswvb0h9fA@mail.gmail.com>
 <20140107141154.GI3182@lee--X1>
 <20140107141916.GG31886@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140107141916.GG31886@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Jan 2014, Mark Brown wrote:

> On Tue, Jan 07, 2014 at 02:11:54PM +0000, Lee Jones wrote:
> 
> > > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> > I'm happy with that, although I haven't heard from Mark for ages.
> 
> > Mark, are you still tracking this?
> 
> Yes, I've been waiting for both Linus and your testing of Takashi's fix.

Hmm... yes I need to get round to that, but it's not dependant on the
other patches in the set.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
