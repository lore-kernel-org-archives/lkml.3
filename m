Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaLOKSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:18:02 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49190 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaLOKR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:17:59 -0500
Date: Mon, 15 Dec 2014 11:17:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: tglx@linutronix.de, gnomes@lxorguk.ukuu.org.uk,
        computersforpeace@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/4] Documentation/SubmitChecklist: Remind submitters to
 check the merge window
Message-ID: <20141215101757.GC6444@pd.tnic>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
 <1418623790-28429-3-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1418623790-28429-3-git-send-email-cernekee@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 10:09:48PM -0800, Kevin Cernekee wrote:
> Currently the checklist does not provide an indication of appropriate
> times to send patches; add a brief note on the topic.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>  Documentation/SubmitChecklist | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/SubmitChecklist b/Documentation/SubmitChecklist
> index 2b7e32d..8b23f9c 100644
> --- a/Documentation/SubmitChecklist
> +++ b/Documentation/SubmitChecklist
> @@ -107,3 +107,8 @@ kernel patches.
>      CONFIG_SMP, CONFIG_SYSFS, CONFIG_PROC_FS, CONFIG_INPUT, CONFIG_PCI,
>      CONFIG_BLOCK, CONFIG_PM, CONFIG_MAGIC_SYSRQ,
>      CONFIG_NET, CONFIG_INET=n (but latter with CONFIG_NET=y)
> +
> +27: For patches which are not urgent fixes for bugs in the current tree,
> +    double-check https://www.kernel.org/ to make sure the merge window is
> +    CLOSED ("mainline:" showing an -rc kernel) before sending.  For more
> +    information on the release cycle, see Documentation/development-process/.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
