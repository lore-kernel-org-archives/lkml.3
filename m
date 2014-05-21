Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaEUJ0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:26:35 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:59945 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaEUJ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:26:32 -0400
Date: Wed, 21 May 2014 10:26:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Matt Porter <mporter@linaro.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/4] mfd: bcm590xx: add support for secondary I2C
 slave address
Message-ID: <20140521092626.GF6679@lee--X1>
References: <1398295293-11033-1-git-send-email-mporter@linaro.org>
 <1398295293-11033-3-git-send-email-mporter@linaro.org>
 <20140428115627.GY21279@lee--X1>
 <20140428140910.GB7719@beef>
 <20140520161131.GB32025@lee--X1>
 <20140520190055.GQ12304@sirena.org.uk>
 <20140520202923.GT32082@beef>
 <20140520214439.GS12304@sirena.org.uk>
 <20140520215726.GU32082@beef>
 <20140520221758.GH12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140520221758.GH12304@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Mark Brown wrote:

> On Tue, May 20, 2014 at 05:57:26PM -0400, Matt Porter wrote:
> > On Tue, May 20, 2014 at 10:44:39PM +0100, Mark Brown wrote:
> 
> > > I looked at that but it seems I already acked the regulator part of the
> > > series and nothing else looked immediately relevant?
> 
> > The series has cross dependencies (shared header include) and thus needs
> > to have both the mfd and regulator portions merged together. You had
> > mentioned in the v1 version that you'd like to take it through the
> > regulator tree and so Lee's comments earlier were with regard to you
> > taking the mfd portions.
> 
> Right, OK - because it depends on the earlier MFD patches (I think?) I
> was expecting it to be applied in MFD and merged over to regulator.

Great, that's all I needed to know.  I'm on it.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
