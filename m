Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaBTVAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:00:54 -0500
Received: from mail-bn1lp0157.outbound.protection.outlook.com ([207.46.163.157]:50084
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbaBTVAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:00:53 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "rja@sgi.com" <rja@sgi.com>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLMZ9xGM3QUTlOk+rIS3zgvGkBZq+l00AgAAHJxWAAAUvD4AAAHeA
Date: Thu, 20 Feb 2014 21:00:48 +0000
Message-ID: <1392930047.20109.6.camel@x230>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
	 <20140220201458.GA7099@sgi.com> <1392927381.20109.0.camel@x230>
	 <20140220204028.GJ17949@sgi.com> <1392929163.20109.5.camel@x230>
	 <20140220205901.GM17949@sgi.com>
In-Reply-To: <20140220205901.GM17949@sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(199002)(189002)(51704005)(24454002)(377424004)(19580405001)(81342001)(76796001)(76786001)(19580395003)(83322001)(94946001)(74366001)(77096001)(95416001)(81686001)(2656002)(74706001)(80976001)(69226001)(51856001)(53806001)(85306002)(93516002)(87266001)(86362001)(74502001)(87936001)(94316002)(74876001)(81542001)(74662001)(63696002)(93136001)(33646001)(81816001)(31966008)(33716001)(83072002)(46102001)(80022001)(65816001)(47976001)(85852003)(92566001)(4396001)(92726001)(54316002)(47446002)(77982001)(56776001)(59766001)(54356001)(76482001)(47736001)(50986001)(49866001)(90146001)(56816005)(79102001)(95666003)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB423;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:B8FE7625.AC195F05.B1F3038B.9ED250C5.20163;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <02563F5EFB9A7A4E877C05141F2D2B32@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1KL11kg021497

On Thu, 2014-02-20 at 14:59 -0600, Russ Anderson wrote:
> On Thu, Feb 20, 2014 at 08:46:04PM +0000, Matthew Garrett wrote:
> > On Thu, 2014-02-20 at 14:40 -0600, Russ Anderson wrote:
> > 
> > > This is also a problem for systems with functional BMCs.  Our
> > > large cluster systems do all IPMI traffic (monitoring) through
> > > a system controller back door.  We do not want the kernel
> > > doing IPMI commands on those systems.
> > 
> > Why not?
> 
> Because some customers want to use cpu cycles for their
> application and let the ipmi monitoring go on through
> the system controller network.

Why is it generating any significant amount of CPU load? We're not
talking about a high-bandwidth interface here.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
