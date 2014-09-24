Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbaIXE1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 00:27:33 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:17148 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724AbaIXE1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 00:27:31 -0400
Date: Tue, 23 Sep 2014 21:27:38 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Pawel Moll <pawel.moll@arm.com>,
        Andy Gross <agross@codeaurora.org>,
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
Message-ID: <20140924042737.GQ10179@sonymobile.com>
References: <1411428329-23172-1-git-send-email-bjorn.andersson@sonymobile.com>
 <54212CA0.4030700@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <54212CA0.4030700@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23 Sep 01:17 PDT 2014, Srinivas Kandagatla wrote:

> Hi Bjorn,
> 
> Thankyou for the new patchset.
> 
> I got few device-tree patches for apq8064 usb, sata, phy and hdmi which 
> depend on rpm header file. It will be nice to get this functionality 
> into 3.18.
> 

We should be able to send out the dts patches separate of these.

> Do you think we should take these patches via arm-soc tree?
> 

Both Lee and Mark indicated that they will pull the parts individually. However
both of the patches depend on the header file created in patch 1, someone needs
to take both for it to work out?

Regards,
Bjorn
