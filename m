Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbaGYMxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:53:41 -0400
Received: from [207.46.163.212] ([207.46.163.212]:43480 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759892AbaGYMxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:53:39 -0400
From: Srikanth Thokala <srikanth.thokala@xilinx.com>
To: Michal Simek <michals@xilinx.com>,
        =?utf-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        "monstr@monstr.eu" <monstr@monstr.eu>
CC: Vinod Koul <vinod.koul@intel.com>, Michal Simek <michals@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: RE: [PATCH v2 07/11] Documentation: devicetree: Fix Xilinx VDMA
 specification
Thread-Topic: [PATCH v2 07/11] Documentation: devicetree: Fix Xilinx VDMA
 specification
Thread-Index: AQHPp90HFwMNoTsoEk2N7w3yWlvvbpuv9CeAgAAO0wCAALfckA==
Date: Fri, 25 Jul 2014 12:51:41 +0000
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
 <1406242820-20140-8-git-send-email-afaerber@suse.de>
 <53D20C19.5000306@monstr.eu> <53D21983.8060901@suse.de>
 <53D225F2.4070504@xilinx.com>
In-Reply-To: <53D225F2.4070504@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.17.39]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <32b0ee01-c15a-47eb-94c5-a60ca5016b85@BY2FFO11FD024.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(13464003)(377454003)(189002)(164054003)(51704005)(479174003)(24454002)(199002)(92566001)(76482001)(81542001)(107046002)(21056001)(23676002)(92726001)(31966008)(77096002)(81342001)(50986999)(85306003)(74502001)(53416004)(54356999)(76176999)(31696002)(50466002)(80022001)(46102001)(79102001)(104016003)(106466001)(95666004)(74316001)(70736001)(86362001)(87936001)(83322001)(20776003)(64706001)(1496007)(85852003)(77982001)(6806004)(19580395003)(4396001)(2656002)(93886003)(74662001)(99396002)(44976005)(47776003)(19580405001)(83072002)(106116001)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB044;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=srikanth.thokala@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6PCrkF6032629

Hi Andreas,

> -----Original Message-----
> From: Michal Simek [mailto:michal.simek@xilinx.com]
> Sent: Friday, July 25, 2014 3:10 PM
> To: Andreas FÃ¤rber; monstr@monstr.eu; Srikanth Thokala
> Cc: Vinod Koul; Michal Simek; Andreas Olofsson; Matteo Vit; Sean Rickerd;
> devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; Rob Herring; Pawel Moll; Mark Rutland; Ian Campbell;
> Kumar Gala
> Subject: Re: [PATCH v2 07/11] Documentation: devicetree: Fix Xilinx VDMA
> specification
>
> Hi Andreas,
>
> On 07/25/2014 10:46 AM, Andreas FÃ¤rber wrote:
> > Hi Michal,
> >
> > Am 25.07.2014 09:49, schrieb Michal Simek:
> >> On 07/25/2014 01:00 AM, Andreas FÃ¤rber wrote:
> >>> The specification requires xlnx,data-width, but example and driver
> >>> use xlnx,datawidth. Change the specification to match the implementation.
> >>>
> >>> Signed-off-by: Andreas FÃ¤rber <afaerber@suse.de>
> >>> ---
> >>>  v2: New
> >>>
> >>>  Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git
> >>> a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> >>> b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> >>> index 1405ed0..e4c4d47 100644
> >>> --- a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> >>> +++ b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> >>> @@ -25,7 +25,7 @@ Required child node properties:
> >>>  - compatible: It should be either "xlnx,axi-vdma-mm2s-channel" or
> >>>   "xlnx,axi-vdma-s2mm-channel".
> >>>  - interrupts: Should contain per channel VDMA interrupts.
> >>> -- xlnx,data-width: Should contain the stream data width, take
> >>> values
> >>> +- xlnx,datawidth: Should contain the stream data width, take values
> >>>   {32,64...1024}.
> >
> > BTW I just notice that this values specification is ambiguous as to
> > whether 96 is a valid value or only powers of 2 like 128. Maybe you
> > want to clarify that in a follow-up patch?
>
> really appreciate your help for improving this.
> Srikanth T: Can you please look at it?

It should be only power of 2.  I could send a patch, but it is design-specific and
the design will not allow to take the intermediate values and so the device-tree
script.  So, I feel it should be fine to keep this way.

Thanks for this patch.

Srikanth

>
> Thanks,
> Michal
>
>



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
