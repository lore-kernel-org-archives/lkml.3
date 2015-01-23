Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbbAWLmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:42:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37557 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbbAWLmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:42:35 -0500
Date: Fri, 23 Jan 2015 12:42:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, corbet@lwn.net, akpm@linux-foundation.org,
        mingo@kernel.org, riel@redhat.com
Subject: Re: [PATCH] Doc: Add default behavior of panic parameter in
 kernel.txt
Message-ID: <20150123114229.GE22635@pd.tnic>
References: <1422001207-13097-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1422001207-13097-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 05:20:07PM +0900, Masanari Iida wrote:
> This patch adds default behavior of panic parameter in kernel.txt
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  Documentation/sysctl/kernel.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 75511ef..3cae2bd 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -527,6 +527,8 @@ panic:
>  The value in this file represents the number of seconds the kernel
>  waits before rebooting on a panic. When you use the software watchdog,
>  the recommended setting is 60.
> +A value of 0 will disable rebooting on a panic.
> +The default is 0.

Just copy the Kconfig text for uniformity (well, almost - it might need
adjusting to fit the tone/nomenclature of that file):

          A value of 0, then we wait forever. A timeout value n > 0 will
          wait n seconds before rebooting, while a timeout value n < 0
          will reboot immediately.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
