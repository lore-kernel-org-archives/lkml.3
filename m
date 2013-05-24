Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3EXOLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:11:36 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:4691
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310Ab3EXOLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:11:35 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MNB3EZ-02-6M1-02
X-M-MSG: 
Date: Fri, 24 May 2013 09:11:24 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH V2 2/3] x86, microcode, intel: Correct typo in printk
Message-ID: <20130524141124.GB13275@jshin-Toonie>
References: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
 <1369323618-5820-3-git-send-email-jacob.shin@amd.com>
 <20130524084350.GC23402@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130524084350.GC23402@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 10:43:50AM +0200, Borislav Petkov wrote:
> On Thu, May 23, 2013 at 10:40:17AM -0500, Jacob Shin wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > User-visible so correct it.
> > 
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > ---
> >  arch/x86/kernel/microcode_intel_early.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
> > index 88f0edc..5e558eb 100644
> > --- a/arch/x86/kernel/microcode_intel_early.c
> > +++ b/arch/x86/kernel/microcode_intel_early.c
> > @@ -529,7 +529,7 @@ int save_mc_for_early(u8 *mc)
> >  	 */
> >  	ret = save_microcode(&mc_saved_data, mc_saved_tmp, mc_saved_count);
> >  	if (ret) {
> > -		pr_err("Can not save microcode patch.\n");
> > +		pr_err("Cannot save microcode patches from initrd.\n");
> 
> This doesn't look like the diff I sent you, please redo against latest
> Linus tree when redoing your patchset.

Oops, the patch didn't apply cleanly for me, so I hand fixed it up,
but I think I did it wrong. I'll fix that. Thanks.

