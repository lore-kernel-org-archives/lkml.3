Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaLOKPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:15:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39062 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbaLOKPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:15:15 -0500
Date: Mon, 15 Dec 2014 11:15:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: tglx@linutronix.de, gnomes@lxorguk.ukuu.org.uk,
        computersforpeace@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/4] Documentation: Add cutoff periods for patch acceptance
Message-ID: <20141215101512.GB6444@pd.tnic>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
 <1418623790-28429-4-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1418623790-28429-4-git-send-email-cernekee@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 10:09:49PM -0800, Kevin Cernekee wrote:
> This has been a recurring source of confusion for the new submitters who
> I've helped; let's see if adding a small illustration improves the
> situation.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>  Documentation/development-process/5.Posting | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/Documentation/development-process/5.Posting b/Documentation/development-process/5.Posting
> index 14f8b01..50cf4dc 100644
> --- a/Documentation/development-process/5.Posting
> +++ b/Documentation/development-process/5.Posting
> @@ -35,6 +35,22 @@ merge window has closed.  You can visit https://www.kernel.org/ to check
>  the merge window status; it is closed if the "mainline:" entry shows a
>  version number containing "-rc", and open if a non-rc version number appears.
>  
> +In many cases, feature additions received and accepted somewhere in the range
> +of [N-rc1, N-rc5) will be merged into the -next tree targeting the (N+1) Linux
> +release.  For example:
> +
> +  kernel.org "mainline:"  |  Patch may appear
> +  field when posted       |  in released kernel
> +  ------------------------+--------------------------------
> +  3.18-rc[1-4]            |  3.19
> +  3.18-rc[5-9]            |  3.20
> +  3.18                    |  Merge window open - don't post
> +  3.19-rc[1-4]            |  3.20
> +  3.19-rc[5-9]            |  3.21
> +  3.19                    |  Merge window open - don't post
> +
> +Bug fixes can typically be accepted at any time.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
