Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3EHCGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:06:36 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42562 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab3EHCGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:06:34 -0400
Date: Tue, 7 May 2013 19:06:26 -0700
From: Matt Helsley <matthltc@linux.vnet.ibm.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 10/48] Audit: change type of audit_ever_enabled to
 bool
Message-ID: <20130508020626.GD24627@us.ibm.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1367893269-9308-11-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367893269-9308-11-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050802-9360-0000-0000-000012132A46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 10:20:31AM +0800, Gao feng wrote:
> It's better to define audit_ever_enabled as bool
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  kernel/audit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 4595a9e..1138ff5 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -76,7 +76,7 @@ static int	audit_initialized;
>  #define AUDIT_OFF	0
>  #define AUDIT_ON	1
>  #define AUDIT_LOCKED	2
> -int		audit_ever_enabled;
> +bool		audit_ever_enabled;

I think you're better off placing this at the beginning of the series
and submitting it separately since it's only incidentally related to
this RFC.

Cheers,
	-Matt Helsley

