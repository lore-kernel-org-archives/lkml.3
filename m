Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaIXHzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:55:45 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36750 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbaIXHzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:55:42 -0400
Date: Wed, 24 Sep 2014 08:55:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Andy Gross <agross@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v7 0/3] Qualcomm Resource Power Manager driver
Message-ID: <20140924075535.GD17801@lee--X1>
References: <1411428329-23172-1-git-send-email-bjorn.andersson@sonymobile.com>
 <54212CA0.4030700@linaro.org>
 <20140924042737.GQ10179@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140924042737.GQ10179@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014, Bjorn Andersson wrote:

> On Tue 23 Sep 01:17 PDT 2014, Srinivas Kandagatla wrote:
> 
> > Hi Bjorn,
> > 
> > Thankyou for the new patchset.
> > 
> > I got few device-tree patches for apq8064 usb, sata, phy and hdmi which 
> > depend on rpm header file. It will be nice to get this functionality 
> > into 3.18.
> > 
> 
> We should be able to send out the dts patches separate of these.
> 
> > Do you think we should take these patches via arm-soc tree?
> > 
> 
> Both Lee and Mark indicated that they will pull the parts individually. However
> both of the patches depend on the header file created in patch 1, someone needs
> to take both for it to work out?

Once reviewed I can take the whole set with Mark's Ack.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
