Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaB0SFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:05:20 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:58737 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaB0SFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:05:15 -0500
MIME-Version: 1.0
In-Reply-To: <85ec4eb2fddf48bfa281928393b0c992@BL2PR03MB226.namprd03.prod.outlook.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
	<1393228996-14787-3-git-send-email-zhangwm@marvell.com>
	<20140225011839.GD7540@shlinux1.ap.freescale.net>
	<175CCF5F49938B4D99B2E3EF7F558EBE54EC413563@SC-VEXCH4.marvell.com>
	<6ad74d797ecc473f922ffdb58c3e9c70@BN1PR03MB235.namprd03.prod.outlook.com>
	<175CCF5F49938B4D99B2E3EF7F558EBE54EC4135A5@SC-VEXCH4.marvell.com>
	<bce87beb86d34377ac3dae0645622edf@BN1PR03MB235.namprd03.prod.outlook.com>
	<20140225181234.GF23275@saruman.home>
	<175CCF5F49938B4D99B2E3EF7F558EBE54EC413885@SC-VEXCH4.marvell.com>
	<c3b92dae0fe54efc85b886899ddf60ab@BN1PR03MB235.namprd03.prod.outlook.com>
	<20140226152336.GI30028@saruman.home>
	<85ec4eb2fddf48bfa281928393b0c992@BL2PR03MB226.namprd03.prod.outlook.com>
Date: Thu, 27 Feb 2014 15:05:14 -0300
Message-ID: <CAOMZO5CSeN0-+U1vCHwUWzdACbLNZcyJYM63YjGJdM=-4oR-xA@mail.gmail.com>
Subject: Re: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
From: Fabio Estevam <festevam@gmail.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: "balbi@ti.com" <balbi@ti.com>, Neil Zhang <zhangwm@marvell.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 12:30 AM, Peter Chen <Peter.Chen@freescale.com> wrote:

>> btw, when can I remove fsl_udc_core.c from the tree ?
>>
>
> Freescale has other processor group (PowerPC, etc) has used this code now.

Not only PowerPC, but also the imx platforms that have not been
converted to device tree yet.
