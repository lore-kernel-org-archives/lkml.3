Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaBEDPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 22:15:39 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:14808 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754207AbaBEDPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 22:15:33 -0500
X-Forefront-Antispam-Report: CIP:157.56.240.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz9371Ic3f2I542I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275dh1de097h186068hz2fh109h2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah224fh1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1fe8h1ff5h2216h22d0h2336h2461h2487h24d7h2516h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009001)(6009001)(13464003)(51704005)(501624003)(377454003)(189002)(199002)(164054003)(87936001)(53806001)(74316001)(76482001)(85306002)(80976001)(54356001)(66066001)(65816001)(51856001)(76576001)(56776001)(54316002)(74502001)(74662001)(47446002)(74706001)(76796001)(31966008)(19580405001)(83322001)(76786001)(33646001)(92566001)(79102001)(2656002)(19580395003)(74876001)(46102001)(15975445006)(94946001)(93136001)(80022001)(94316002)(81342001)(81686001)(81542001)(90146001)(85852003)(59766001)(63696002)(77982001)(83072002)(74366001)(69226001)(86362001)(56816005)(93516002)(47736001)(49866001)(2201001)(4396001)(87266001)(50986001)(47976001)(81816001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR05MB527;H:DM2PR05MB671.namprd05.prod.outlook.com;CLIP:66.129.239.13;FPR:FCBDCB8E.B1F290D1.7BE47333.8E8DA61.202EE;InfoNoRecordsMX:1;A:1;LANG:en;
From: Rajat Jain <rajatjain@juniper.net>
To: Rajat Jain <rajatxjain@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>
CC: Guenter Roeck <groeck@juniper.net>
Subject: RE: [PATCH v4 0/8] Allow Link state changes for Hot-Plug
Thread-Topic: [PATCH v4 0/8] Allow Link state changes for Hot-Plug
Thread-Index: AQHPIhnuAog6p1MDKkK0k4ut2ogHHJql/GCQ
Date: Wed, 5 Feb 2014 03:15:19 +0000
Message-ID: <4f93bb24b6214bfb9dbcc91b682184eb@DM2PR05MB671.namprd05.prod.outlook.com>
References: <52F1A1B6.2090709@gmail.com>
In-Reply-To: <52F1A1B6.2090709@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.239.13]
x-forefront-prvs: 01136D2D90
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s153FjeQ026728

Hello list,

My apologies for I forgot to attach the version history information of each individual patch.

Essentially the v4 is exactly same as v3, except that it is rebased on top of 3.14-rc1.

Thanks,

Rajat

> -----Original Message-----
> From: Rajat Jain [mailto:rajatxjain@gmail.com]
> Sent: Tuesday, February 04, 2014 6:28 PM
> To: Bjorn Helgaas; Rafael J. Wysocki; Kenji Kaneshige; Alex Williamson;
> Yijing Wang; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org;
> Yinghai Lu
> Cc: Guenter Roeck; Rajat Jain; Rajat Jain
> Subject: [PATCH v4 0/8] Allow Link state changes for Hot-Plug
> 
> Hello,
> 
> This patch set enables the use of PCI Express link up and link down
> events for Hotplug or Unplug. This is the pretty much the same patchset
> as v3, only resending after rebasing on top of 3.14-rc1.
> 
> (As a side effect, this patch also fixes the bug
> https://bugzilla.kernel.org/show_bug.cgi?id=65521 )
> 
> I'd appreciate if you could please review and provide me with any
> comments.
> 
> Thanks,
> 
> Rajat
> 
> Rajat Jain (8):
>   pciehp: Make check_link_active() non-static
>   pciehp: Use link change notifications for hot-plug and removal
>   pciehp: Enable link state change notifications
>   pciehp: Don't disable the link permanently, during removal
>   pciehp: Don't check for adapter or latch status while disabling
>   pciehp: Disabling the link notification across slot reset
>   pciehp: Ensure very fast hotplug events are also processed.
>   pciehp: Introduce hotplug_lock to serialize HP events
> 
>  drivers/pci/hotplug/pciehp.h      |    5 ++
>  drivers/pci/hotplug/pciehp_core.c |    7 +-
>  drivers/pci/hotplug/pciehp_ctrl.c |  149
> ++++++++++++++++++++++++++++++-------
>  drivers/pci/hotplug/pciehp_hpc.c  |   74 +++++++++---------
>  4 files changed, 169 insertions(+), 66 deletions(-)
> 
> --
> 1.7.9.5
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
