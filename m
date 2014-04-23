Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaDWJcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:32:39 -0400
Received: from [207.46.163.209] ([207.46.163.209]:38621 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750860AbaDWJch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:32:37 -0400
Date: Wed, 23 Apr 2014 16:23:02 +0800
From: Peter Chen <peter.chen@freescale.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] usb: chipidea: msm: Clean and fix glue layer
 driver
Message-ID: <20140423082259.GA22549@shlinux1.ap.freescale.net>
References: <1398159797-26917-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1398159797-26917-1-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(51704005)(189002)(199002)(81342001)(4396001)(19580405001)(83322001)(44976005)(79102001)(81542001)(23726002)(50466002)(6806004)(54356999)(77096999)(20776003)(80976001)(33656001)(74662001)(74502001)(31966008)(15975445006)(97756001)(83506001)(86362001)(85852003)(19580395003)(47776003)(76176999)(80022001)(83072002)(46102001)(99396002)(46406003)(92566001)(76482001)(77982001)(92726001)(87936001)(50986999);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB019;H:az84smr01.freescale.net;FPR:98C5FC92.BC10D451.73612BC2.E0678252.20206;MLV:sfv;PTR:gate-az5.freescale.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 01901B3451
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 12:43:14PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> This series intend to fix driver, which was broken for a while.
> It is used to create peripheral role device, which in coordination
> with phy-usb-msm driver could provide USB2.0 gadget support for
> Qualcomm targets.
> 
> Changes since version 2.
> 
>  - Rename devicetree description file to ci-hdrc-qcom.txt to be in-line
>    with Freescale and Zevio naming scheme
>  - Use better name for usb-phy phandle.
>  - Make of_device_id structure const
> 
> [1] https://lkml.org/lkml/2014/2/18/209
> 
> Ivan T. Ivanov (3):
>   usb: chipidea: msm: Add device tree binding information
>   usb: chipidea: msm: Add device tree support
>   usb: chipidea: msm: Initialize offset of the capability registers
> 
>  .../devicetree/bindings/usb/ci-hdrc-qcom.txt       | 17 +++++++++++++++
>  drivers/usb/chipidea/ci_hdrc_msm.c                 | 24 +++++++++++++++++++++-
>  2 files changed, 40 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-qcom.txt
> 
> --
> 1.8.3.2
> 
> 
> 

This patchset looks ok except the typo which Srinivas Kandagatla mentions.

-- 

Best Regards,
Peter Chen
