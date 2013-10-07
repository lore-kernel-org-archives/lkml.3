Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab3JGRNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:13:14 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:23959
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753218Ab3JGRNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:13:10 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "open list:Hyper-V CORE AND..." <devel@linuxdriverproject.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] hyperv-fb: add pci stub
Thread-Topic: [PATCH 1/2] hyperv-fb: add pci stub
Thread-Index: AQHOv2bVQASfGfm0ykyTRCW4KfZb6JnheAxggAdcMICAAK2d4A==
Date: Mon, 7 Oct 2013 17:12:53 +0000
Message-ID: <f5746838b7654aac98a5753d669196b4@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1380714911-6254-1-git-send-email-kraxel@redhat.com>
	 <465ef0cb45e04bcc94c4788c0d930c4d@SN2PR03MB061.namprd03.prod.outlook.com>
 <1381128633.13574.3.camel@nilsson.home.kraxel.org>
In-Reply-To: <1381128633.13574.3.camel@nilsson.home.kraxel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.147.219]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 09928BEC91
x-forefront-antispam-report: SFV:NSPM;SFS:(189002)(199002)(24454002)(377454003)(52604005)(13464003)(51704005)(377424004)(74706001)(76482001)(56776001)(66066001)(50986001)(49866001)(63696002)(53806001)(69226001)(4396001)(33646001)(47976001)(79102001)(74366001)(85306002)(47736001)(83072001)(46102001)(54356001)(80022001)(80976001)(81686001)(77982001)(59766001)(65816001)(54316002)(19580405001)(83322001)(76796001)(74662001)(74502001)(47446002)(19580395003)(76576001)(77096001)(31966008)(56816003)(81542001)(81816001)(81342001)(51856001)(74876001)(76786001)(74316001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:131.107.147.219;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r97HDJLG029013



> -----Original Message-----
> From: Gerd Hoffmann [mailto:kraxel@redhat.com]
> Sent: Sunday, October 06, 2013 11:51 PM
> To: KY Srinivasan
> Cc: Haiyang Zhang; Jean-Christophe Plagniol-Villard; Tomi Valkeinen; open
> list:Hyper-V CORE AND...; open list:FRAMEBUFFER LAYER; open list
> Subject: Re: [PATCH 1/2] hyperv-fb: add pci stub
> 
> On Mi, 2013-10-02 at 14:29 +0000, KY Srinivasan wrote:
> >
> > > This patch adds a pci stub driver to hyper-fb.  The hyperv framebuffer
> > > driver will bind to the pci device then, so linux kernel and userspace
> > > know there is a proper kernel driver for the device active.  lspci shows
> > > this for example:
> 
> > Gerd,
> >
> > Thanks for doing this. This certainly will address some of the issues that are
> reported. I do have a question though - how would this work if we don't have PCI
> bus in the guest.
> 
> The hyperv framebuffer driver wouldn't work in the first place then as
> it looks up the framebuffer address in pci config space (see hvfb_getmem
> function).

We are going to fix this as we move this code to run on our UEFI firmware. 

Regards,

K. Y

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
