Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3EaPRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:17:44 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:20851
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753228Ab3EaPRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:17:37 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI103dK1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
X-WSS-ID: 0MNO558-01-1TP-02
X-M-MSG: 
Date: Fri, 31 May 2013 10:17:30 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>, <mingo@kernel.org>,
        <linux-kernel@vger.kernel.org>, <fenghua.yu@intel.com>,
        <tglx@linutronix.de>, <hpa@linux.intel.com>,
        <linux-tip-commits@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [tip:x86/microcode] x86, microcode, amd: Early microcode patch
 loading support for AMD
Message-ID: <20130531151730.GA14342@jshin-Toonie>
References: <1369940959-2077-5-git-send-email-jacob.shin@amd.com>
 <tip-757885e94a22bcc82beb9b1445c95218cb20ceab@git.kernel.org>
 <20130531084133.GA14076@nazgul.tnic>
 <20130531150241.GA12006@jshin-Toonie>
 <51A8BE05.7060008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <51A8BE05.7060008@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 08:13:09AM -0700, H. Peter Anvin wrote:
> If you send a patch with text above the patch, please include a scissor
> line:
> 
> ---8<---
> 
> ... above the patch so that git tools can process it.

Ah okay, sorry about that, will do so from now on.

Yinghai, Boris, sorry if you have to hand snip my previous fix email,
but please do let me know if I can add your Tested-by's

Thanks!


