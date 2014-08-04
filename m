Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaHDPb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:31:56 -0400
Received: from mail-am1lrp0015.outbound.protection.outlook.com ([213.199.154.15]:38233
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752675AbaHDPby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:31:54 -0400
From: Dotan Barak <dotanb@mellanox.com>
To: Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: checkpatch.pl report about "Missing blank line after
 declarations" in a structure definition
Thread-Topic: checkpatch.pl report about "Missing blank line after
 declarations" in a structure definition
Thread-Index: Ac+v1hsr1olRx4GsR0yoGKahVltZOwAEuFMAAAD6CqAAANNzgAAAjzTwAAD5l4AAADX+UAAAU0AAAAAkPRA=
Date: Mon, 4 Aug 2014 15:31:50 +0000
Message-ID: <c0a27eddd92743828ebe9a737b0b16cd@DB3PR05MB380.eurprd05.prod.outlook.com>
References: <3219ba81002f41d99c8651755dc2a920@DB3PR05MB380.eurprd05.prod.outlook.com>
	 <1407159342.16152.63.camel@joe-AO725>
	 <e68ad593255b4094a79de9b22cbc2a7a@DB3PR05MB380.eurprd05.prod.outlook.com>
	 <1407162439.16152.67.camel@joe-AO725>
	 <f95137f9228a4f08ba391f9640237d28@DB3PR05MB380.eurprd05.prod.outlook.com>
	 <1407165075.16152.70.camel@joe-AO725>
	 <3b44a1bc344f40feb7c8119a4b102494@DB3PR05MB380.eurprd05.prod.outlook.com>
 <1407165996.16152.75.camel@joe-AO725>
In-Reply-To: <1407165996.16152.75.camel@joe-AO725>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(24454002)(377424004)(13464003)(189002)(199002)(377454003)(164054003)(50986999)(33646002)(4396001)(99396002)(87936001)(83072002)(95666004)(86362001)(77982001)(19580395003)(2656002)(107046002)(92566001)(19580405001)(79102001)(93886004)(85306004)(74316001)(81542001)(85852003)(31966008)(21056001)(101416001)(110136001)(106356001)(74502001)(54356999)(83322001)(105586002)(64706001)(76176999)(81342001)(66066001)(46102001)(76576001)(76482001)(80022001)(74662001)(20776003)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:DB3PR05MB379;H:DB3PR05MB380.eurprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I guess I need to refresh my regular expression skills ...)

Thanks, this will be just great!
Dotan

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Monday, August 04, 2014 6:27 PM
> To: Dotan Barak
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: checkpatch.pl report about "Missing blank line after
> declarations" in a structure definition
> 
> On Mon, 2014-08-04 at 15:19 +0000, Dotan Barak wrote:
> > In our code (I take it as an example), we used
> > MLX5_DECLARE_DOORBELL_LOCK, So I guess that the regular expression
> > that you mentioned will fail on it (because the "_" is not allowed to be
> repeated).
> >
> > So, I would change it a little bit to allow people to use underscore as a word
> separator.
> []
> > > Maybe:
> > >
> > > (?:$Storage\s+)(?:[A-Z_][A-Z0-9]+_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-
> > > 9]+){1,2}
> 
> What I suggested should allow any of:
> 
> 	DECLARE_FOO
> 	_FOO_DEFINE_BAR
> 	FOO_BAR_DEFINE_BAZ
> 	FOO_BAR_DECLARE_BAZ_QUX
> 
> where FOO/BAR/BAZ/QUX can also have digits

