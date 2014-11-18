Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbaKRVqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:46:05 -0500
Received: from smtprelay.synopsys.com ([198.182.44.111]:43294 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaKRVqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:46:02 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "balbi@ti.com" <balbi@ti.com>,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH]  usb: gadget: USB3 support to the legacy printer driver
Thread-Topic: [PATCH]  usb: gadget: USB3 support to the legacy printer driver
Thread-Index: AQHQAr0NM6ip+f4vtE6njx4rWhy/JpxmDlYAgADnqACAABBJgIAAKxyAgAACXoCAAC0AgIAAAYQA//+INAA=
Date: Tue, 18 Nov 2014 21:45:13 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844EDA05@US01WEMBX2.internal.synopsys.com>
References: <546A829A.8030106@linaro.org> <20141118003028.GA11280@saruman>
 <546B5578.8040809@linaro.org> <20141118151753.GB8223@saruman>
 <546B874B.8060700@linaro.org> <20141118180039.GJ6179@saruman>
 <546BAF07.1050605@linaro.org> <20141118204708.GR6179@saruman>
In-Reply-To: <20141118204708.GR6179@saruman>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Felipe Balbi
> Sent: Tuesday, November 18, 2014 12:47 PM
> 
> On Tue, Nov 18, 2014 at 03:41:43PM -0500, Jorge Ramirez-Ortiz wrote:
> >
> > notice that the original PLX driver was still far from the theoretical 5Gbps
> > target (I was expecting to measure at least 3Gbps and could only get 1Gbps).
> > So 1Gbps should be the target to meet on the kernel.org net2280 - do you agree?
> 
> this depends on a whole bunch of things. Mainline is a lot different
> from PLX's kernel tree, I'm sure.
> 
> It also depends on how many PCIe lanes you're using. Just because USB3
> guarantees 5Gbps bandwidth, if you use a 1x PCIe connector, you'll never
> get that ;-)

Being pedantic, USB3 runs at 4Gbps, not 5Gbps. The signal transitions
on the bus are at 5GT/s (5 giga-transitions per second), but due to the
8b/10b encoding, that equates to 4Gbps data rate.

-- 
Paul

