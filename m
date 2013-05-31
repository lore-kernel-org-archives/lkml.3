Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3EaPyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:54:13 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:29371
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843Ab3EaPyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:54:10 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
X-WSS-ID: 0MNO6U4-01-4BH-02
X-M-MSG: 
Date: Fri, 31 May 2013 10:54:02 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 4/4] microcode/x86/amd: early microcode patch loading
 support for AMD
Message-ID: <20130531155402.GA15667@jshin-Toonie>
References: <1369940959-2077-1-git-send-email-jacob.shin@amd.com>
 <1369940959-2077-5-git-send-email-jacob.shin@amd.com>
 <20130531042649.GA4488@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130531042649.GA4488@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 01:26:49AM -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 30 May 2013, Jacob Shin wrote:
> >  mkdir initrd
> >  cd initrd
> > -mkdir kernel
> > -mkdir kernel/x86
> > -mkdir kernel/x86/microcode
> > -cp ../microcode.bin kernel/x86/microcode/GenuineIntel.bin
> > -find .|cpio -oc >../ucode.cpio
> > +mkdir -p kernel/x86/microcode
> > +cp ../microcode.bin kernel/x86/microcode/GenuineIntel.bin (or AuthenticAMD.bin)
> 
> Can I just 
> 'cat /lib/firmware/amd-ucode/*bin >kernel/x86/microcode/AuthenticAMD.bin' 
> to get a valid microcode container for all amd processors?
> 
> The answer for Intel is "yes".  I sure hope it is the same for AMD...

Hm. I have not thought about that, I will investigate and follow up
with a patch if needed.

Thanks,

