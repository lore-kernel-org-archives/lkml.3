Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab3EWVYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 17:24:41 -0400
Received: from [213.199.154.188] ([213.199.154.188]:18566 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759165Ab3EWVYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 17:24:39 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI103dK1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MN9SQE-01-1S4-02
X-M-MSG: 
Date: Thu, 23 May 2013 16:23:01 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 0/3] x86/microcode: early microcode patch loading
 support on AMD
Message-ID: <20130523212301.GA13275@jshin-Toonie>
References: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
 <3E5A0FA7E9CA944F9D5414FEC6C712205633D6C3@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C712205633D6C3@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 09:01:21PM +0000, Yu, Fenghua wrote:
> > From: Jacob Shin [mailto:jacob.shin@amd.com]
> > The following patchset adds early microcode patch loading support on
> > AMD systems, on top of the framework introduced by:
> >   https://lkml.org/lkml/2012/12/21/193
> > 
> 
> Could you please change Documentation/x86/early-microcode.txt for AMD? At least please add AMD microcode file in cpio name space: kernel/x86/microcode/AuthenticAMD.bin. Users can generate the cpio file with AMD microcode based on your document.

Ah, yes will do. I'll send out another revision tomorrow.

Thanks!

