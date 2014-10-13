Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaJMMhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:37:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaJMMg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:36:59 -0400
Date: Mon, 13 Oct 2014 08:36:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86, kexec: Add .gitignore file
Message-ID: <20141013123655.GA6466@redhat.com>
References: <1412981721-3432-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412981721-3432-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 06:55:21PM -0400, Prarit Bhargava wrote:
> When doing git-status there are two untracked files:
> 
> \# Untracked files:
> \#   (use "git add <file>..." to include in what will be committed)
> \#
> \#       arch/x86/purgatory/kexec-purgatory.c
> \#       arch/x86/purgatory/purgatory.ro
> 
> Add a .gitignore to block these files.
> 
> Cc: x86@kernel.org
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>

[ CC akpm ]

Thanks Prarit.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  arch/x86/purgatory/.gitignore |    2 ++
>  1 file changed, 2 insertions(+)
>  create mode 100644 arch/x86/purgatory/.gitignore
> 
> diff --git a/arch/x86/purgatory/.gitignore b/arch/x86/purgatory/.gitignore
> new file mode 100644
> index 0000000..e9e66f1
> --- /dev/null
> +++ b/arch/x86/purgatory/.gitignore
> @@ -0,0 +1,2 @@
> +kexec-purgatory.c
> +purgatory.ro
> -- 
> 1.7.9.3
