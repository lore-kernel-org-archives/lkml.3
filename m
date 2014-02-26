Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaBZPoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:44:09 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.88]:2757 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593AbaBZPoE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:44:04 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Gerd Hoffmann <kraxel@redhat.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        KY Srinivasan <kys@microsoft.com>,
        "Abhishek Gupta (LIS)" <abgupta@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: RE: [PATCH v5 2/2] hyperv-fb: kick off efifb early
Thread-Topic: [PATCH v5 2/2] hyperv-fb: kick off efifb early
Thread-Index: AQHPMuDH8zLAbiBGqEm3vZBRa6inhprHrQwg
Date: Wed, 26 Feb 2014 15:43:41 +0000
Message-ID: <7f41262bad3c4043bded61abc759dac7@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1393411885-14895-1-git-send-email-kraxel@redhat.com>
 <1393411885-14895-3-git-send-email-kraxel@redhat.com>
In-Reply-To: <1393411885-14895-3-git-send-email-kraxel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(377454003)(189002)(199002)(13464003)(51704005)(76482001)(69226001)(81686001)(80022001)(93516002)(54356001)(85306002)(47976001)(31966008)(94316002)(74876001)(47736001)(65816001)(66066001)(50466002)(74662001)(20776003)(80976001)(47776003)(63696002)(84676001)(4396001)(79102001)(47446002)(44976005)(74502001)(19580405001)(83322001)(19580395003)(6806004)(53806001)(74706001)(77982001)(2656002)(87266001)(59766001)(46102001)(56776001)(76786001)(93136001)(83072002)(85852003)(95666003)(81542001)(81342001)(87936001)(76796001)(46406003)(86612001)(95416001)(74366001)(23726002)(94946001)(50986001)(51856001)(90146001)(49866001)(81816001)(56816005)(33646001)(54316002)(92566001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB597;H:hybrid.exchange.microsoft.com;FPR:34EE793E.2BD155CA.FDE01B03.B0AFC813.201C0;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0134AD334F
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Gerd Hoffmann [mailto:kraxel@redhat.com]
> Sent: Wednesday, February 26, 2014 5:51 AM
> To: linux-fbdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; KY Srinivasan;
> Abhishek Gupta (LIS); Haiyang Zhang; jasowang@redhat.com;
> tomi.valkeinen@ti.com; devel@linuxdriverproject.org; Gerd Hoffmann; Jean-
> Christophe Plagniol-Villard
> Subject: [PATCH v5 2/2] hyperv-fb: kick off efifb early
> 
> Remove firmware framebuffer before initializing hyperv-fb.  Needed
> on gen2 virtual machines.   Letting register_framebuffer handle the
> switchover results in efifb still being active while hyperv graphics
> are initialized, which in turn can make the linux kernel hang.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

Thank you!

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

