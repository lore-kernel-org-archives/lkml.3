Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab3KVRsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:48:39 -0500
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:40788
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753339Ab3KVRsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:48:38 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "matt@console-pimps.org" <matt@console-pimps.org>,
        "richard@nod.at" <richard@nod.at>, "cxie@redhat.com" <cxie@redhat.com>
Subject: Re: [PATCH] x86, efi: add no_bricked_efi whitelist
Thread-Topic: [PATCH] x86, efi: add no_bricked_efi whitelist
Thread-Index: AQHO5ctsbQuFm47B1katHCc9ePY1AJovbqbwgADxyq6AAGsLuIAAvw4A
Date: Fri, 22 Nov 2013 17:48:34 +0000
Message-ID: <1385142514.2884.2.camel@x230>
References: <528C740A.6010407@jp.fujitsu.com>
	 <1384963376.20536.3.camel@x230> <528DD3E0.3050606@jp.fujitsu.com>
	 <1385064722.12107.1.camel@x230> <528E9EB2.3060808@jp.fujitsu.com>
	 <1385078632.12107.3.camel@x230> <528EF87D.4050300@jp.fujitsu.com>
In-Reply-To: <528EF87D.4050300@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.6.207.143]
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(199002)(189002)(24454002)(59766001)(69226001)(76786001)(74876001)(76796001)(83072001)(77982001)(33646001)(74706001)(81816001)(56816003)(56776001)(85306002)(77096001)(33716001)(54316002)(50986001)(47976001)(81686001)(19580395003)(2656002)(74662001)(81342001)(74366001)(83322001)(19580405001)(81542001)(47736001)(87936001)(31966008)(49866001)(65816001)(80022001)(4396001)(87266001)(47446002)(80976001)(74502001)(54356001)(66066001)(79102001)(51856001)(63696002)(76482001)(46102001)(53806001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB423;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:209.6.207.143;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E44339335945846AFB69BC34463BFA1@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAMHmjgB024707

On Fri, 2013-11-22 at 15:23 +0900, Yasuaki Ishimatsu wrote:

> I don't know how to implement your idea. But if GC run by your idea, the free
> space may spread out. So 1) case is solved. But it does not solve 2) case.
> In my opinion, if system has sane firmware, all nvram strage should be used.
> I will send whiltelist version which used DMI infomation. Please review it.

We don't want to solve (2). The benefit in doing so is small compared to
the cost of maintaining a whitelist or risking breaking systems.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
