Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3FLTbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 15:31:51 -0400
Received: from [213.199.154.188] ([213.199.154.188]:6110 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751411Ab3FLTbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 15:31:49 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MOAOWA-02-RVU-02
X-M-MSG: 
Date: Wed, 12 Jun 2013 14:31:19 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Borislav Petkov <bp@alien8.de>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 0/2] x86/microcode/amd: early loading fixes
Message-ID: <20130612193119.GB15934@jshin-Toonie>
References: <1370658140-5299-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1370658140-5299-1-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 09:22:18PM -0500, Jacob Shin wrote:
> This patchset addreses two problems with early loading on AMD.
> 
> First, feedback from Yinghai that find_ucode_in_initrd() should be
> marked __init:
>   https://lkml.org/lkml/2013/6/4/695
> 
> And second, feedback from Henrique that Intel early loading supports
> multiple microcode firmware concatenated together, whereas the current
> AMD implementation lacks this support:
>   https://lkml.org/lkml/2013/5/31/4
> 
> V3:
> * style fix -- reduce multiple if statements into a single one

Hi hpa or Yinghai, just wondering if you had the chance to look at this
V3 yet.

Thank you,

