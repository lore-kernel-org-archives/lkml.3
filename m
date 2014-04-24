Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaDXCEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 22:04:39 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:42215
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750897AbaDXCEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 22:04:37 -0400
Date: Thu, 24 Apr 2014 08:38:57 +0800
From: Peter Chen <peter.chen@freescale.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] usb: chipidea: msm: Clean and fix glue layer
 driver
Message-ID: <20140424003854.GA25407@shlinux1.ap.freescale.net>
References: <1398256084-6815-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1398256084-6815-1-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(24454002)(199002)(189002)(19580395003)(83072002)(50466002)(87936001)(79102001)(99396002)(44976005)(19580405001)(80976001)(83322001)(31966008)(6806004)(74502001)(77982001)(74662001)(85852003)(15975445006)(81542001)(4396001)(46102001)(81342001)(46406003)(50986999)(47776003)(20776003)(97756001)(92566001)(83506001)(23726002)(77096999)(92726001)(33656001)(80022001)(76176999)(76482001)(54356999)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB028;H:az84smr01.freescale.net;FPR:F6D7F891.8C12DF13.B3613BE8.50E48252.20237;MLV:sfv;PTR:gate-az5.freescale.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 01917B1794
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 03:28:01PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> This series intend to fix driver, which was broken for a while.
> It is used to create peripheral role device, which in coordination
> with phy-usb-msm driver could provide USB2.0 gadget support for
> Qualcomm targets.
> 
> Changes since version 3.
> 
>  - Fix typo in devicetree description file.
> 
> Previews version can be found here:

Since in your phy's patchset, you also access portsc which is in
chipidea register region, it is not a standard way.
In case, you will change something at chipidea driver in future
when you re-work your next revision phy's patchset, I do not
send this patchset to Greg right now.

Once your phy's patchset has accepted, notify me. I will send
this patchset to Greg.

Peter

> 
> https://lkml.org/lkml/2014/4/22/195
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

-- 

Best Regards,
Peter Chen
