Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab3BNIio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 03:38:44 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46670 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab3BNIin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 03:38:43 -0500
Date: Thu, 14 Feb 2013 00:38:39 -0800
From: Joel Becker <jlbec@evilplan.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH review 26/85] ocfs2: Enable building with user namespaces
 enabled
Message-ID: <20130214083838.GG18408@localhost>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	linux-fsdevel@vger.kernel.org,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
	Mark Fasheh <mfasheh@suse.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
 <1360777934-5663-26-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360777934-5663-26-git-send-email-ebiederm@xmission.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 09:51:15AM -0800, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Now that ocfs2 has been converted to store uids and gids in
> kuid_t and kgid_t and all of the conversions have been added
> to the appropriate places it is safe to allow building and
> using ocfs2 with user namespace support enabled.
> 
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  init/Kconfig |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index f516d52..9cb63c9 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1076,7 +1076,6 @@ config UIDGID_CONVERTED
>  	depends on NCP_FS = n
>  	depends on NFSD = n
>  	depends on NFS_FS = n
> -	depends on OCFS2_FS = n

Ahh, I can see how this protects the partially applied state.  Sorry
about that.

Joel

>  	depends on XFS_FS = n
>  
>  config UIDGID_STRICT_TYPE_CHECKS
> -- 
> 1.7.5.4
> 

-- 

"People with narrow minds usually have broad tongues."

			http://www.jlbec.org/
			jlbec@evilplan.org
