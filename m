Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab3KGLGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:06:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57409 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3KGLGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:06:50 -0500
Date: Thu, 7 Nov 2013 03:06:45 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 17/24] ocfs2: Convert use of typedef ctl_table to struct
 ctl_table
Message-ID: <20131107110645.GE24799@localhost>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	ocfs2-devel@oss.oracle.com
References: <cover.1382480758.git.joe@perches.com>
 <f5f72664f6f5b3b433149e515cacbd0d90bf99f9.1382480758.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5f72664f6f5b3b433149e515cacbd0d90bf99f9.1382480758.git.joe@perches.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 03:30:00PM -0700, Joe Perches wrote:
> This typedef is unnecessary and should just be removed.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Joel Becker <jlbec@evilplan.org>
> ---
>  fs/ocfs2/stackglue.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index 39abf89..cb7ec0b 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -643,7 +643,7 @@ error:
>  
>  #define FS_OCFS2_NM		1
>  
> -static ctl_table ocfs2_nm_table[] = {
> +static struct ctl_table ocfs2_nm_table[] = {
>  	{
>  		.procname	= "hb_ctl_path",
>  		.data		= ocfs2_hb_ctl_path,
> @@ -654,7 +654,7 @@ static ctl_table ocfs2_nm_table[] = {
>  	{ }
>  };
>  
> -static ctl_table ocfs2_mod_table[] = {
> +static struct ctl_table ocfs2_mod_table[] = {
>  	{
>  		.procname	= "nm",
>  		.data		= NULL,
> @@ -665,7 +665,7 @@ static ctl_table ocfs2_mod_table[] = {
>  	{ }
>  };
>  
> -static ctl_table ocfs2_kern_table[] = {
> +static struct ctl_table ocfs2_kern_table[] = {
>  	{
>  		.procname	= "ocfs2",
>  		.data		= NULL,
> @@ -676,7 +676,7 @@ static ctl_table ocfs2_kern_table[] = {
>  	{ }
>  };
>  
> -static ctl_table ocfs2_root_table[] = {
> +static struct ctl_table ocfs2_root_table[] = {
>  	{
>  		.procname	= "fs",
>  		.data		= NULL,
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
> 

-- 

Life's Little Instruction Book #451

	"Don't be afraid to say, 'I'm sorry.'"

			http://www.jlbec.org/
			jlbec@evilplan.org
