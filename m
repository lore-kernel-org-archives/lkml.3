Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391AbaDITxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:53:44 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:56389 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006AbaDITxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:53:43 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH v2] NTFS: Remove NULL value assignments
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <20140409190128.573f05f235cc227617bb76b2@skynet.be>
Date: Wed, 9 Apr 2014 20:53:39 +0100
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Fabian Frederick <fabf@skynet.be>
Content-Transfer-Encoding: 7bit
Message-Id: <934A5C29-9468-473C-8747-D5513ED96E7B@tuxera.com>
References: <20140409190128.573f05f235cc227617bb76b2@skynet.be>
To: akpm <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Please could you merge this via your patch series?  Thanks a lot in advance!

Best regards,

	Anton

On 9 Apr 2014, at 18:01, Fabian Frederick <fabf@skynet.be> wrote:

> Static values are automatically initialized to NULL.
> 
> Acked-by: Anton Altaparmakov <anton@tuxera.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Anton Altaparmakov <anton@tuxera.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> fs/ntfs/compress.c | 2 +-
> fs/ntfs/super.c    | 4 ++--
> fs/ntfs/sysctl.c   | 2 +-
> 3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> index ee4144c..f82498c 100644
> --- a/fs/ntfs/compress.c
> +++ b/fs/ntfs/compress.c
> @@ -58,7 +58,7 @@ typedef enum {
> /**
>  * ntfs_compression_buffer - one buffer for the decompression engine
>  */
> -static u8 *ntfs_compression_buffer = NULL;
> +static u8 *ntfs_compression_buffer;
> 
> /**
>  * ntfs_cb_lock - spinlock which protects ntfs_compression_buffer
> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index 9de2491..6c3296e 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c
> @@ -50,8 +50,8 @@
> static unsigned long ntfs_nr_compression_users;
> 
> /* A global default upcase table and a corresponding reference count. */
> -static ntfschar *default_upcase = NULL;
> -static unsigned long ntfs_nr_upcase_users = 0;
> +static ntfschar *default_upcase;
> +static unsigned long ntfs_nr_upcase_users;
> 
> /* Error constants/strings used in inode.c::ntfs_show_options(). */
> typedef enum {
> diff --git a/fs/ntfs/sysctl.c b/fs/ntfs/sysctl.c
> index 79a8918..1927170 100644
> --- a/fs/ntfs/sysctl.c
> +++ b/fs/ntfs/sysctl.c
> @@ -56,7 +56,7 @@ static ctl_table sysctls_root[] = {
> };
> 
> /* Storage for the sysctls header. */
> -static struct ctl_table_header *sysctls_root_table = NULL;
> +static struct ctl_table_header *sysctls_root_table;
> 
> /**
>  * ntfs_sysctl - add or remove the debug sysctl

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge
J.J. Thomson Avenue, Cambridge, CB3 0RB, UK

