Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab3LEQfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:35:24 -0500
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:20419
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932576Ab3LEQfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:35:20 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "pavel@ucw.cz" <pavel@ucw.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove unnecessarily gendered language
Thread-Topic: [PATCH] Remove unnecessarily gendered language
Thread-Index: AQHO78Wp335rwpc28EKOB9Zlmmg7eZpFb2wAgABg+gA=
Date: Thu, 5 Dec 2013 16:35:15 +0000
Message-ID: <1386261314.14035.8.camel@x230>
References: <1386033532-25431-1-git-send-email-matthew.garrett@nebula.com>
	 <20131205104808.GA6455@amd.pavel.ucw.cz>
In-Reply-To: <20131205104808.GA6455@amd.pavel.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.6.207.143]
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(51704005)(199002)(189002)(377424004)(76482001)(81542001)(81342001)(74876001)(74706001)(47736001)(19580395003)(69226001)(31966008)(74662001)(47446002)(74502001)(85306002)(47976001)(50986001)(83072001)(83322001)(4396001)(49866001)(19580405001)(87936001)(77982001)(56816005)(63696002)(79102001)(2656002)(81686001)(81816001)(33646001)(33716001)(66066001)(65816001)(80022001)(76786001)(76796001)(54356001)(59766001)(51856001)(90146001)(54316002)(80976001)(87266001)(74366001)(77096001)(56776001)(53806001)(46102001)(85852002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB424;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:209.6.207.143;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <08E4DB7EFF4C994797A26CC0AD2BBEBF@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB5GZVTu009554

On Thu, 2013-12-05 at 11:48 +0100, Pavel Machek wrote:
> On Mon 2013-12-02 20:18:52, Matthew Garrett wrote:
> > The kernel as a number of cases of gendered language. The majority of these
> > refer to objects that don't have gender in English, and so I've replaced
> > them with "it" and "its". Some refer to people (developers or users), and
> > I've replaced these with the singular "they" variant. Some are simply
> > typos that I've fixed up.
> 
> Why is this good idea?

Using "he" to refer to objects without gender is (with some exceptions)
incorrect in English, so that set should be uncontroversial. "He" is
usually considered acceptable when referring to an individual of unknown
gender, but so is "they". The latter version has the advantage of not
giving the impression that we believe all our users are male.

> > @@ -127,7 +127,7 @@ gid=
> >  umask=			Provide default owner, group, and access mode mask.
> >  			These options work as documented in mount(8).  By
> >  			default, the files/directories are owned by root and
> > -			he/she has read and write permissions, as well as
> > +			they have read and write permissions, as well as
> >  			browse permission for directories.  No one else has any
> >  			access permissions.  I.e. the mode on all files is by
> >  			default rw------- and for directories rwx------, a
> 
> So... we had unambiguous text "user has read and write permissions"
> and now you have to wonder if they refers to "user" or
> "files/directories".

Reasonable. I'll rework that.

> > @@ -23,7 +24,7 @@ Quota netlink interface
> >  When user exceeds a softlimit, runs out of grace time or reaches hardlimit,
> >  quota subsystem traditionally printed a message to the controlling terminal of
> >  the process which caused the excess. This method has the disadvantage that
> > -when user is using a graphical desktop he usually cannot see the message.
> > +when user is using a graphical desktop they usually cannot see the
> >  message.
> 
> Is this even correct english?

No, but it wasn't to begin with either. I mostly avoided more
significant changes because I didn't want to risk changing existing
meaning.

> NAK, FWIW.

Why?

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
