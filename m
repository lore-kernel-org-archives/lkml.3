Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaLJD1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 22:27:21 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:59764 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaLJD1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 22:27:19 -0500
X-IronPort-AV: E=Sophos;i="5.07,549,1413270000"; 
   d="scan'208";a="52527314"
Message-ID: <5487BD95.1060000@broadcom.com>
Date: Tue, 9 Dec 2014 19:27:17 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Scott Branden" <sbranden@broadcom.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/4] i2c: iProc: define Broadcom iProc I2C binding
References: <rjui@broadcom.com>	<1418172891-19441-1-git-send-email-rjui@broadcom.com>	<1418172891-19441-2-git-send-email-rjui@broadcom.com>	<5487A16C.5000707@gmail.com>	<5487A355.6030704@broadcom.com> <CAEUmHyb_wu1kVj-G5LQj8Q_A1Tid1gSGbU=cGeBf4EXZgXChbg@mail.gmail.com>
In-Reply-To: <CAEUmHyb_wu1kVj-G5LQj8Q_A1Tid1gSGbU=cGeBf4EXZgXChbg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/9/2014 7:12 PM, Varka Bhadram wrote:
>
>
> On Wed, Dec 10, 2014 at 7:05 AM, Ray Jui <rjui@broadcom.com
> <mailto:rjui@broadcom.com>> wrote:
>
>
>
>     On 12/9/2014 5:27 PM, Varka Bhadram wrote:
>
>         Hi,
>
>         On Wednesday 10 December 2014 06:24 AM, Ray Jui wrote:
>
>             Document the I2C device tree binding for Broadcom iProc
>             family of
>             SoCs
>
>             Signed-off-by: Ray Jui <rjui@broadcom.com
>             <mailto:rjui@broadcom.com>>
>             Reviewed-by: Scott Branden <sbranden@broadcom.com
>             <mailto:sbranden@broadcom.com>>
>             ---
>                .../devicetree/bindings/i2c/__brcm,iproc-i2c.txt     |   37
>             ++++++++++++++++++++
>                1 file changed, 37 insertions(+)
>                create mode 100644
>             Documentation/devicetree/__bindings/i2c/brcm,iproc-i2c.__txt
>
>             diff --git
>             a/Documentation/devicetree/__bindings/i2c/brcm,iproc-i2c.__txt
>             b/Documentation/devicetree/__bindings/i2c/brcm,iproc-i2c.__txt
>             new file mode 100644
>             index 0000000..81f982c
>             --- /dev/null
>             +++
>             b/Documentation/devicetree/__bindings/i2c/brcm,iproc-i2c.__txt
>             @@ -0,0 +1,37 @@
>             +Broadcom iProc I2C controller
>             +
>             +Required properties:
>             +
>             +- compatible:
>             +    Must be "brcm,iproc-i2c"
>             +
>             +- reg:
>             +    Define the base and range of the I/O address space that
>             contain
>             the iProc
>             +    I2C controller registers
>             +
>             +- interrupts:
>             +    Should contain the I2C interrupt
>             +
>             +- clock-frequency:
>             +    This is the I2C bus clock. Need to be either 100000 or
>             400000
>             +
>             +- #address-cells:
>             +    Always 1 (for I2C addresses)
>             +
>             +- #size-cells:
>             +    Always 0
>             +
>
>
>         All the properties defined with two lines of statements.
>
>         Why cant they be with single line statement, like:
>
>         compatible:    Must be "brcm,iproc-i2c"
>         reg:        Define the base and range of the I/O address space that
>                   contain the iProc I2C controller registers
>
>         ....
>
>
>     I thought making them two lines are more readable (and obviously
>     that's very subjective, :)). But more importantly, it matches the
>     format of other Broadcom iProc/Cygnus devicetree binding documents
>     that are currently in progress of upstreaming.
>
>
> But max of the bindings over the kernel follows single line statements.
>
> --
> Thanks and Regards,
> Varka Bhadram.
Is it a requirement for these property descriptions to be one line? If 
not, I prefer to stick with the way it is now. Thanks.
