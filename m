Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaLTW3H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 17:29:07 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:45009 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbaLTW3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 17:29:04 -0500
Date: Sat, 20 Dec 2014 14:29:01 -0800 (PST)
X-Google-Original-Date: Sat, 20 Dec 2014 17:29 -0500
From: Paul Moore <paul@paul-moore.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] security: selinux: avc.c:  Remove unused function
Message-ID: <8453909.Gh4Uivx2Wx@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1419078730-31316-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419078730-31316-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 20, 2014 01:32:10 PM Rickard Strandqvist wrote:
> Remove the function avc_sidcmp() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called
> cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  security/selinux/avc.c |    5 -----
>  1 file changed, 5 deletions(-)

Thanks, applied to the SELinux next branch with some minor changes to the 
patch's subject line.

> diff --git a/security/selinux/avc.c b/security/selinux/avc.c
> index a18f1fa..afcc0ae 100644
> --- a/security/selinux/avc.c
> +++ b/security/selinux/avc.c
> @@ -517,11 +517,6 @@ out:
>  	return rc;
>  }
> 
> -static inline int avc_sidcmp(u32 x, u32 y)
> -{
> -	return (x == y || x == SECSID_WILD || y == SECSID_WILD);
> -}
> -
>  /**
>   * avc_update_node Update an AVC entry
>   * @event : Updating event

-- 
paul moore
www.paul-moore.com

