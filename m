Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab3EWSMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 14:12:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36892 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757972Ab3EWSMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 14:12:51 -0400
Message-ID: <1369332769.2075.23.camel@joe-AO722>
Subject: Re: [PATCH V2 2/3] x86, microcode, intel: Correct typo in printk
From: Joe Perches <joe@perches.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Date: Thu, 23 May 2013 11:12:49 -0700
In-Reply-To: <1369323618-5820-3-git-send-email-jacob.shin@amd.com>
References: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
	 <1369323618-5820-3-git-send-email-jacob.shin@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-23 at 10:40 -0500, Jacob Shin wrote:
> User-visible so correct it.
[]
> diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
[]
> @@ -529,7 +529,7 @@ int save_mc_for_early(u8 *mc)
[]
> -		pr_err("Can not save microcode patch.\n");
> +		pr_err("Cannot save microcode patches from initrd.\n");

It seems you enhanced the message rather than fixed
a typo so I think the subject line isn't correct.

