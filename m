Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab3I0FmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 01:42:03 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751813Ab3I0FmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 01:42:01 -0400
Message-ID: <52451AA7.3080204@nod.at>
Date: Fri, 27 Sep 2013 07:41:59 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Michal Marek <mmarek@suse.cz>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/2] um/vdso: add .gitignore for a couple of targets
References: <1380255287-5818-1-git-send-email-artagnon@gmail.com> <1380255287-5818-3-git-send-email-artagnon@gmail.com>
In-Reply-To: <1380255287-5818-3-git-send-email-artagnon@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.09.2013 06:14, schrieb Ramkumar Ramachandra:
> Cc: Richard Weinberger <richard@nod.at>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  arch/x86/um/vdso/.gitignore | 2 ++
>  1 file changed, 2 insertions(+)
>  create mode 100644 arch/x86/um/vdso/.gitignore
> 
> diff --git a/arch/x86/um/vdso/.gitignore b/arch/x86/um/vdso/.gitignore
> new file mode 100644
> index 0000000..9cac6d0
> --- /dev/null
> +++ b/arch/x86/um/vdso/.gitignore
> @@ -0,0 +1,2 @@
> +vdso-syms.lds
> +vdso.lds
> 

Queued for 3.13-rc1.

Thanks,
//richard
