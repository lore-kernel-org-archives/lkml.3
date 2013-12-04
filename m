Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3LDCgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:36:18 -0500
Received: from mail-bn1lp0157.outbound.protection.outlook.com ([207.46.163.157]:4410
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab3LDCgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:36:17 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "geert@linux-m68k.org" <geert@linux-m68k.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove unnecessarily gendered language
Thread-Topic: [PATCH] Remove unnecessarily gendered language
Thread-Index: AQHO78Wp335rwpc28EKOB9Zlmmg7eZpCLciAgAEl3IA=
Date: Wed, 4 Dec 2013 02:36:13 +0000
Message-ID: <1386124571.13344.4.camel@x230.lan>
References: <1386033532-25431-1-git-send-email-matthew.garrett@nebula.com>
	 <CAMuHMdXcHTTmnqCTJWRJU_2vgv3wtB9gFGiR5Z0GF=BDKniXCg@mail.gmail.com>
In-Reply-To: <CAMuHMdXcHTTmnqCTJWRJU_2vgv3wtB9gFGiR5Z0GF=BDKniXCg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.6.207.143]
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(189002)(199002)(51704005)(377424004)(377454003)(46102001)(87936001)(83322001)(19580395003)(19580405001)(76796001)(83072001)(54356001)(76786001)(76482001)(81542001)(2656002)(74876001)(54316002)(51856001)(77096001)(79102001)(56776001)(74706001)(90146001)(56816005)(87266001)(85306002)(36756003)(65816001)(66066001)(80022001)(74366001)(81686001)(81816001)(81342001)(31966008)(4396001)(53806001)(77982001)(33646001)(59766001)(69226001)(74502001)(74662001)(63696002)(80976001)(49866001)(47976001)(47736001)(47446002)(50986001)(85852002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB423;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:209.6.207.143;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <E96FC8AF9CBCCD4FBE3BC4E89A8E1667@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB42aOg6030080

On Tue, 2013-12-03 at 10:04 +0100, Geert Uytterhoeven wrote:
> On Tue, Dec 3, 2013 at 2:18 AM, Matthew Garrett
> <matthew.garrett@nebula.com> wrote:
> > --- a/drivers/scsi/mesh.c
> > +++ b/drivers/scsi/mesh.c
> > @@ -1190,8 +1190,8 @@ static void handle_msgin(struct mesh_state *ms)
> >                         if (tp->sdtr_state != sdtr_sent) {
> >                                 /* reply with an SDTR */
> >                                 add_sdtr_msg(ms);
> > -                               /* limit period to at least his value,
> > -                                  offset to no more than his */
> > +                               /* limit period to at least its value,
> > +                                  offset to no more than its */
> >                                 if (ms->msgout[3] < ms->msgin[3])
> >                                         ms->msgout[3] = ms->msgin[3];
> >                                 if (ms->msgout[4] > ms->msgin[4])
> 
> I think both occurrences of "his" should actually be "this".

Yeah, I wasn't too sure on this one. I think it's trying to say "limit
the output period to at least that of the input, limit the offset to no
more than the input", so "its" refers to the input message. That's
probably an argument for just rewriting the entire comment instead.

> BTW, the singular they  ("The caller must know what they are doing!")
> feels a bit strange to me, but it seems to match the wikipedia article on
> singular they. As a non-native English speaker, I was not familiar with it.

It's a fairly old convention, but I think it's fair to say that it's not
the most common.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
