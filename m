Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaBTVjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:39:45 -0500
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:24847
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751060AbaBTVjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:39:44 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "rja@sgi.com" <rja@sgi.com>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLMZ9xGM3QUTlOk+rIS3zgvGkBZq+l00AgAAHJxWAAAUvD4AACFkLgAAC54A=
Date: Thu, 20 Feb 2014 21:39:23 +0000
Message-ID: <1392932363.20109.11.camel@x230>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
	 <20140220201458.GA7099@sgi.com> <1392927381.20109.0.camel@x230>
	 <20140220204028.GJ17949@sgi.com> <1392929163.20109.5.camel@x230>
	 <20140220205901.GM17949@sgi.com> <1392930047.20109.6.camel@x230>
	 <20140220212854.GO17949@sgi.com>
In-Reply-To: <20140220212854.GO17949@sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(24454002)(199002)(189002)(377424004)(51704005)(63696002)(54316002)(77096001)(76482001)(65816001)(92566001)(90146001)(80022001)(51856001)(85852003)(93136001)(56816005)(94316002)(53806001)(54356001)(95416001)(74706001)(81686001)(94946001)(74876001)(56776001)(81816001)(47736001)(50986001)(93516002)(76796001)(2656002)(33646001)(79102001)(59766001)(83072002)(46102001)(47446002)(77982001)(86362001)(49866001)(87936001)(80976001)(85306002)(47976001)(76786001)(87266001)(19580405001)(83322001)(74502001)(19580395003)(33716001)(74366001)(81342001)(31966008)(74662001)(69226001)(4396001)(81542001)(92726001)(95666003)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB422;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:FF88F220.2D3AD4E9.71F5353C.8EE6D141.201FF;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <206F5026A351C348A378D2DB54C2CD2C@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1KLdpNq021913

On Thu, 2014-02-20 at 15:28 -0600, Russ Anderson wrote:

> For some customers _any_ amount is significant, especially
> on large clustered systems where the amount is multiplied
> by tens or hundreds of thousands of nodes.
> 
> You many not think wasting their cpu cycles is important, but they do.

Then they should be running locally built kernels in order to ensure
that there's no problematic code running at all. Distribution kernels
will always contain code that some customers won't be interested in, and
some of that code will end up executing.

If you have specific bug reports, that would be helpful. But you're not
describing actual failure conditions or showing any willingness to
figure out what the underlying problem is. The BMC is generating
messages and handing them off to the host. If that's taking more than a
tiny number of cycles, why? Once we know the answer to that, we can
actually put some effort into fixing it.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
