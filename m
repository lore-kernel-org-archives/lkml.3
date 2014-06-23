Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaFWSqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:46:03 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:52256 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaFWSqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:46:00 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Robert Baldyga <r.baldyga@samsung.com>, "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "andrzej.p@samsung.com" <andrzej.p@samsung.com>
Subject: RE: [PATCH 00/11] usb: dwc2/gadget: fix series
Thread-Topic: [PATCH 00/11] usb: dwc2/gadget: fix series
Thread-Index: AQHPjrf/5TpNhxxKqkauGTRu27XYeZt/Bepw
Date: Mon, 23 Jun 2014 18:45:59 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844B9CED@US01WEMBX2.internal.synopsys.com>
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
In-Reply-To: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
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
> Sent: Monday, June 23, 2014 12:51 AM
> 
> Hello,
> 
> This patchset contains fixes for dwc2 gadget driver. It touches PHY,
> FIFO configuration, initialization sequence and adds many other small fixes.

Hi Robert,

I have a couple of questions/suggestions on patches #6 and #10. Other
than that,

for the entire series,
Acked-by: Paul Zimmerman <paulz@synopsys.com>

I think we should also have Felipe's ACK for the parts that concern the
PHY framework and the gadget API.

-- 
Paul

