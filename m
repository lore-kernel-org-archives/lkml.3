Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbaGQA1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:27:17 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:39022 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbaGQA1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:27:14 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Robert Baldyga <r.baldyga@samsung.com>, "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "andrzej.p@samsung.com" <andrzej.p@samsung.com>
Subject: RE: [PATCH v2 00/12] usb: dwc2/gadget: fix series
Thread-Topic: [PATCH v2 00/12] usb: dwc2/gadget: fix series
Thread-Index: AQHPoN/j+g6HSwJVtUaYykO7pirJvpujaKXQ
Date: Thu, 17 Jul 2014 00:27:12 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844BEC8C@US01WEMBX2.internal.synopsys.com>
References: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
In-Reply-To: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Robert Baldyga [mailto:r.baldyga@samsung.com]
> Sent: Wednesday, July 16, 2014 3:22 AM
> 
> This patchset contains fixes for dwc2 gadget driver. It touches PHY,
> FIFO configuration, initialization sequence and adds many other small fixes.
> 
> Best regards
> Robert Baldyga
> Samsung R&D Institute Poland
> 
> Changelog:
> v2:
>  - add patch usb: dwc2/gadget: avoid disabling ep0
>  - fix FIFO flushing when it's assigned to endpoint dynamically
>  - write to proper FIFO in s3c_hsotg_write_fifo() function
>  - use real FIFO size in kill_all_requests
>  - fix comment in s3c_hsotg_init_fifo() function
> 
> v1: https://lkml.org/lkml/2014/6/23/67

Hi Robert,

For v1, I gave my Ack for the entire series, but I don't see my Ack on
any of these. Any reason for that?

-- 
Paul

