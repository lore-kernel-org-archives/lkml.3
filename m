Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3FFO3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:29:12 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:56331
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200Ab3FFO3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:29:10 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MNZ6WD-01-3Y9-02
X-M-MSG: 
Date: Thu, 6 Jun 2013 09:28:59 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>
Subject: Re: [PATCH 0/2] x86/microcode/amd: early loading fixes
Message-ID: <20130606142859.GA4835@jshin-Toonie>
References: <1370463236-2115-1-git-send-email-jacob.shin@amd.com>
 <20130605221833.GA15427@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130605221833.GA15427@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 12:18:33AM +0200, Borislav Petkov wrote:
> On Wed, Jun 05, 2013 at 03:13:54PM -0500, Jacob Shin wrote:
> > This patchset addreses two problems with early loading on AMD.
> 
> It would be nice if, in the future, you put the maintainers of this
> driver to CC.

Oops, sorry about that, I meant to do so, will do on V2 today.

> 
> Unless you're volunteering up for maintaining it...
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 

