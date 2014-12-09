Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaLIJvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:51:02 -0500
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:18752
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752845AbaLIJu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:50:59 -0500
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2014 04:50:59 EST
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv4] dmaengine: fsl-edma: fixup reg offset and hw S/G
 support in big-endian model
Thread-Topic: [PATCHv4] dmaengine: fsl-edma: fixup reg offset and hw S/G
 support in big-endian model
Thread-Index: AQHP7dxw0ZXsnje90ESiN3180LVrWZyHROAAgAAEwWA=
Date: Tue, 9 Dec 2014 09:35:47 +0000
Message-ID: <BN3PR0301MB1236551BC121795218B2EAB387650@BN3PR0301MB1236.namprd03.prod.outlook.com>
References: <1413968035-12855-1-git-send-email-jingchang.lu@freescale.com>
 <20141209091248.GA16827@intel.com>
In-Reply-To: <20141209091248.GA16827@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.51]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1235;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1235;
x-forefront-prvs: 0420213CCD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(51704005)(13464003)(24454002)(199003)(189002)(66654002)(41574002)(97736003)(40100003)(110136001)(99286002)(107046002)(105586002)(106116001)(106356001)(21056001)(4396001)(102836002)(74316001)(76576001)(122556002)(46102003)(68736005)(31966008)(101416001)(19580405001)(19580395003)(54206007)(33656002)(120916001)(20776003)(54606007)(62966003)(99396003)(87936001)(64706001)(77156002)(66066001)(50986999)(76176999)(54356999)(2656002)(92566001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1235;H:BN3PR0301MB1236.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB99pB64030744

Hi, Vinod,
  
  Many thanks!
  I resend the patch just before I saw this email, please ignore the
resend one since they are the same.


Thanks and Best Regards,
Jingchang

>-----Original Message-----
>From: Vinod Koul [mailto:vinod.koul@intel.com]
>Sent: Tuesday, December 09, 2014 5:13 PM
>To: Lu Jingchang-B35083
>Cc: dmaengine@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>linux-kernel@vger.kernel.org
>Subject: Re: [PATCHv4] dmaengine: fsl-edma: fixup reg offset and hw S/G
>support in big-endian model
>
>On Wed, Oct 22, 2014 at 04:53:55PM +0800, Jingchang Lu wrote:
>> The offset of all 8-/16-bit registers in big-endian eDMA model are
>> swapped in a 32-bit size opposite those in the little-endian model.
>>
>> The hardware Scatter/Gather requires the subsequent TCDs stored in
>> memory in little endian independent of the register endian model, the
>> eDMA engine will do the swap if need.
>>
>> This patch also use regular assignment for tcd variables r/w instead
>> of with io function previously that may not always be true.
>Applied, thanks
>
>--
>~Vinod


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
