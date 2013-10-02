Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3JBU70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:59:26 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.92]:35535 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580Ab3JBU7Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:59:24 -0400
X-Greylist: delayed 887 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Oct 2013 16:59:24 EDT
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Gerd Hoffmann <kraxel@redhat.com>
CC: KY Srinivasan <kys@microsoft.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "open list:Hyper-V CORE AND..." <devel@linuxdriverproject.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] hyperv-fb: add pci stub
Thread-Topic: [PATCH 1/2] hyperv-fb: add pci stub
Thread-Index: AQHOv2bnsUgDKm/6iE+bN5r3vuKv1Jnh4BJQ
Date: Wed, 2 Oct 2013 20:42:02 +0000
Message-ID: <f163f7a7f4804187821668ce53e19119@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1380714911-6254-1-git-send-email-kraxel@redhat.com>
In-Reply-To: <1380714911-6254-1-git-send-email-kraxel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.17;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(13464003)(377454003)(51704005)(199002)(189002)(80976001)(46102001)(44976005)(47736001)(50466002)(19580395003)(83322001)(19580405001)(6806004)(4396001)(49866001)(47976001)(50986001)(56816003)(76786001)(33646001)(76796001)(85306001)(74876001)(65816001)(59766001)(74706001)(81816001)(81686001)(66066001)(83072001)(51856001)(79102001)(74502001)(47446002)(74662001)(56776001)(76482001)(81542001)(23726002)(81342001)(54356001)(74366001)(53806001)(54316002)(31966008)(80022001)(63696002)(77982001)(69226001)(46406003)(20776003)(47776003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB602;H:hybrid.exchange.microsoft.com;CLIP:131.107.1.17;FPR:;RD:mail1.exchange.microsoft.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0987ACA2E2
X-OriginatorOrg: DuplicateDomain-b1291ffc-369c-4c2a-9225-e2908f70a426.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of Gerd Hoffmann
> Sent: Wednesday, October 2, 2013 7:55 AM
> Cc: Gerd Hoffmann; KY Srinivasan; Haiyang Zhang; Jean-Christophe Plagniol-
> Villard; Tomi Valkeinen; open list:Hyper-V CORE AND...; open
> list:FRAMEBUFFER LAYER; open list
> Subject: [PATCH 1/2] hyperv-fb: add pci stub
> 
> This patch adds a pci stub driver to hyper-fb.  The hyperv framebuffer driver
> will bind to the pci device then, so linux kernel and userspace know there is a
> proper kernel driver for the device active.  lspci shows this for example:
> 
> [root@dhcp231 ~]# lspci -vs8
> 00:08.0 VGA compatible controller: Microsoft Corporation Hyper-V virtual
> VGA (prog-if 00 [VGA controller])
>         Flags: bus master, fast devsel, latency 0, IRQ 11
>         Memory at f8000000 (32-bit, non-prefetchable) [size=64M]
>         Expansion ROM at <unassigned> [disabled]
>         Kernel driver in use: hyperv_fb
> 
> Another effect is that the xorg vesa driver will not attach to the device and
> thus the Xorg server will automatically use the fbdev driver instead.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

Acked-by: Haiyang Zhang <haiyangz@microsoft.com>

Thank you for fixing this!

- Haiyang


