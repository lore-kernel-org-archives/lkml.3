Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3GPIwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:52:07 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12205 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab3GPIwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:52:01 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-3a-51e509af4447
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: "'Randy Dunlap'" <rdunlap@infradead.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'USB list'" <linux-usb@vger.kernel.org>
References: <20130715134528.8e4977b2c2623d749d23d5ab@canb.auug.org.au>
 <51E41B37.6080801@infradead.org>
In-reply-to: <51E41B37.6080801@infradead.org>
Subject: RE: linux-next: Tree for Jul 15 (usb gadget and rdnis)
Date: Tue, 16 Jul 2013 10:51:51 +0200
Message-id: <003301ce8201$b785f1f0$2691d5d0$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6BdARht0N/L0RDRAWTJxEAFLAkKAAjU/0g
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xq7rrOZ8GGry/wWlxedccNouDC9sY
	LRYta2W2eHtnOovF1r1X2R1YPRpv3GDz2LxCy+PzJrkA5igum5TUnMyy1CJ9uwSujC8XLjAX
	HOOpOPR9JnMD43OuLkYODgkBE4mrmyu7GDmBTDGJC/fWs3UxcnEICSxllJg+rZERwmlgkmj7
	uZQJpIpNwFhi78EORpBmEYFwiVnnuEDCzAJpEn+PbmMDsYUEMiU+3r4OZnMK6ErsPHODBcQW
	FrCXWNf1DyzOIqAqMXnOP7CRvALWEpvmPWeBsAUlfky+xwIxU0ti/c7jTBC2vMTmNW+ZIW5W
	l3j0VxckLCJgJLHq7yFGiBIRibsNz1knMArNQjJpFpJJs5BMmoWkZQEjyypG0dTS5ILipPRc
	Q73ixNzi0rx0veT83E2MkPD/soNx8TGrQ4wCHIxKPLySPE8ChVgTy4orcw8xSnAwK4nwJm4C
	CvGmJFZWpRblxxeV5qQWH2Jk4uCUamAUM27nXTSlf/K83C7hHoe1pufcRX6uzT9159Hz4uIS
	j2cftMMePSvU2Ohi4Td999p1514GT0hWMg29UqXsNOnGnb5VYRvv6n1dIZrU9uryO7kPNSu3
	dxYETNl2/oAW/5EqMX/DX/OuNhlbOzqyXGT/2irTvcb7nfb2TVek1LUKjGL3u78qqOlTYinO
	SDTUYi4qTgQAOP0o/F0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

On Monday, July 15, 2013 5:55 PM Randy Dunlap wrote:

> On 07/14/13 20:45, Stephen Rothwell wrote:
> > Hi all,
> >
> > The merge window is closed.  Time to clean up all those unclean trees.
> > The good among you can just fast forward to v3.11-rc1 ;-)
> >
> > Changes since 20130712:
> >
> 
> on x86_64:
> 
> ERROR: "rndis_msg_parser" [drivers/usb/gadget/usb_f_rndis.ko] undefined!
> ERROR: "rndis_signal_disconnect" [drivers/usb/gadget/usb_f_rndis.ko]
> undefined!
> ERROR: "rndis_get_next_response" [drivers/usb/gadget/usb_f_rndis.ko]
> undefined!
> ERROR: "rndis_signal_connect" [drivers/usb/gadget/usb_f_rndis.ko]
> undefined!
> ERROR: "rndis_set_param_vendor" [drivers/usb/gadget/usb_f_rndis.ko]
> undefined!
> ERROR: "rndis_register" [drivers/usb/gadget/usb_f_rndis.ko] undefined!
> ERROR: "rndis_uninit" [drivers/usb/gadget/usb_f_rndis.ko] undefined!
> ERROR: "rndis_deregister" [drivers/usb/gadget/usb_f_rndis.ko] undefined!
> ERROR: "rndis_rm_hdr" [drivers/usb/gadget/usb_f_rndis.ko] undefined!
> ERROR: "rndis_free_response" [drivers/usb/gadget/usb_f_rndis.ko]
undefined!
> ERROR: "rndis_add_hdr" [drivers/usb/gadget/usb_f_rndis.ko] undefined!
> ERROR: "rndis_set_host_mac" [drivers/usb/gadget/usb_f_rndis.ko] undefined!
> ERROR: "rndis_set_param_medium" [drivers/usb/gadget/usb_f_rndis.ko]
> undefined!
> ERROR: "rndis_set_param_dev" [drivers/usb/gadget/usb_f_rndis.ko]
undefined!
> 
> 
> Full randconfig file is attached.
> 
> 

There is a patch for that:

http://www.mail-archive.com/linux-usb@vger.kernel.org/msg24015.html

Andrzej


