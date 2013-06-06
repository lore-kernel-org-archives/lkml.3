Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3FFVQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:16:35 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:9823
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594Ab3FFVQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:16:34 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(zz98dIbafdM1432I4015Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MNZPRD-02-3R7-02
X-M-MSG: 
Date: Thu, 6 Jun 2013 15:06:03 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Joe Perches <joe@perches.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 4/4] microcode/x86/amd: early microcode patch loading
 support for AMD
Message-ID: <20130606200603.GA6952@jshin-Toonie>
References: <1369940959-2077-1-git-send-email-jacob.shin@amd.com>
 <1369940959-2077-5-git-send-email-jacob.shin@amd.com>
 <20130531042649.GA4488@khazad-dum.debian.net>
 <20130531193200.GA8346@alberich>
 <20130531213039.GA13307@khazad-dum.debian.net>
 <20130601011512.GA8532@jshin-Toonie>
 <20130605221042.GE29856@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130605221042.GE29856@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 12:10:42AM +0200, Borislav Petkov wrote:
> On Fri, May 31, 2013 at 08:15:12PM -0500, Jacob Shin wrote:
> > Any thoughts on this Boris?
> 
> Looks ok to me - I'm assuming you're testing all this new code on all
> families...?

Thanks, I have sent out a V2 of this patch. This time I remembered to
CC you on it :-) (sorry about V1)

Yes the new early load bits have been tested on variety of families,
and also 32 vs 64 bits, loading on cold boot vs suspend/resume, single
family container file vs multiple container files appended together,
.. etc.

