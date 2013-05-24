Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab3EXInq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:43:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44035 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab3EXInn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:43:43 -0400
Date: Fri, 24 May 2013 10:43:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH V2 2/3] x86, microcode, intel: Correct typo in printk
Message-ID: <20130524084350.GC23402@nazgul.tnic>
References: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
 <1369323618-5820-3-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1369323618-5820-3-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 10:40:17AM -0500, Jacob Shin wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> User-visible so correct it.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  arch/x86/kernel/microcode_intel_early.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
> index 88f0edc..5e558eb 100644
> --- a/arch/x86/kernel/microcode_intel_early.c
> +++ b/arch/x86/kernel/microcode_intel_early.c
> @@ -529,7 +529,7 @@ int save_mc_for_early(u8 *mc)
>  	 */
>  	ret = save_microcode(&mc_saved_data, mc_saved_tmp, mc_saved_count);
>  	if (ret) {
> -		pr_err("Can not save microcode patch.\n");
> +		pr_err("Cannot save microcode patches from initrd.\n");

This doesn't look like the diff I sent you, please redo against latest
Linus tree when redoing your patchset.
