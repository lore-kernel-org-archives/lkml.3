Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068AbaHZIMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:12:06 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:35422
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932497AbaHZIL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:11:59 -0400
Message-ID: <1409040709.4167.1.camel@leyfoon-vm>
Subject: Re: [PATCH] net: stmmac: fix warning from Sparse for socfpga
From: Ley Foon Tan <lftan@altera.com>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
CC: <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vince Bridgers <vbridger@altera.com>
Date: Tue, 26 Aug 2014 16:11:49 +0800
In-Reply-To: <53FC3F89.9030406@st.com>
References: <1409037076-14775-1-git-send-email-lftan@altera.com>
	 <53FC363E.6050604@st.com>
	 <CAFiDJ5_LspyDPnXnimZ=TRiZD191XQRvwqgfZSOU-ziu_DUx=Q@mail.gmail.com>
	 <53FC3F89.9030406@st.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(199003)(189002)(377424004)(24454002)(46102001)(21056001)(4396001)(97736001)(74502001)(104166001)(85306004)(93886004)(50986999)(31966008)(74662001)(76482001)(95666004)(50226001)(103116003)(77982001)(23676002)(102836001)(77096002)(64706001)(87286001)(76176999)(107046002)(99396002)(50466002)(81342001)(47776003)(80022001)(79102001)(77156001)(106466001)(83322001)(81542001)(105596002)(42186005)(87936001)(44976005)(6806004)(88136002)(86362001)(68736004)(92726001)(92566001)(93916002)(90102001)(89996001)(84676001)(62966002)(33646002)(20776003)(33716001)(83072002)(85852003)(110136001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB043;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03152A99FF
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sel, 2014-08-26 at 10:04 +0200, Giuseppe CAVALLARO wrote:

> 
> >
> >>
> >> patch should be for net-next
> > Do you mean the patch need based on net-next git?
> 
> yes I do.
> 
> > I'm using linux-next git now.
> 
> ok, can you signal it in the subject (e.g.  [PATCH (net-next)]
> This can help on reviewing and IIRC required by Maintainer too
Sure, will do it in next revision. 

Thanks.

Regards
Ley Foon
