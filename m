Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab3KEWxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:53:41 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:18472
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755713Ab3KEWxj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:53:39 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(z33fclz4015Idbb0izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzz8275ch1d7338h17326ah1de097h186068hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216hbe9i1155h)
From: Stuart Yoder <B08248@freescale.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kim.phillips@linaro.org" <kim.phillips@linaro.org>
Subject: driver core patches
Thread-Topic: driver core patches
Thread-Index: Ac7aedvd0hns3ndWTCm68Q+mlo9iMw==
Date: Tue, 5 Nov 2013 22:53:36 +0000
Message-ID: <9F6FE96B71CF29479FF1CDC8046E15036F480C@039-SN1MPN1-002.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.84.194]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Any feedback on the driver core patches in Kim Phillips patch series
from mid-October?

The 3rd patch of the series has some open issues related to vfio-pci,
but the first two are driver core related and am wondering if they
are acceptable.

[PATCH 1/4] driver core: Add new device_driver flag to allow binding via sysfs only
http://www.spinics.net/lists/kvm/msg97198.html
[PATCH 2/4] driver core: platform: allow platform drivers to bind to any device
http://www.spinics.net/lists/kvm/msg97195.html

If you have any issues, we would like to get them addressed.

Thanks,
Stuart Yoder

