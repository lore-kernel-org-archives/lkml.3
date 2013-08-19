Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169Ab3HSRAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:00:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37338 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3HSRAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:00:20 -0400
Message-ID: <52124F1B.5060100@infradead.org>
Date: Mon, 19 Aug 2013 10:00:11 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: linux-kernel@vger.kernel.org, rob@landley.net, linux-doc@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] documentations: treewide: Fix typo in Documentations/filesystems
References: <1376887857-11538-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1376887857-11538-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/13 21:50, Masanari Iida wrote:
> Correct spelling typo in Documentations/filesystems.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

This probably can also go via trivial@kernel.org.

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> 
> ---
>  Documentation/filesystems/btrfs.txt     | 2 +-
>  Documentation/filesystems/f2fs.txt      | 2 +-
>  Documentation/filesystems/nfs/Exporting | 2 +-
>  Documentation/filesystems/qnx6.txt      | 2 +-
>  Documentation/filesystems/xfs.txt       | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
> index b349d57..9dae594 100644
> --- a/Documentation/filesystems/btrfs.txt
> +++ b/Documentation/filesystems/btrfs.txt
> @@ -87,7 +87,7 @@ Unless otherwise specified, all options default to off.
>  
>    device=<devicepath>
>  	Specify a device during mount so that ioctls on the control device
> -	can be avoided.  Especialy useful when trying to mount a multi-device
> +	can be avoided.  Especially useful when trying to mount a multi-device
>  	setup as root.  May be specified multiple times for multiple devices.
>  
>    discard
> diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
> index 3cd27be..3b57456 100644
> --- a/Documentation/filesystems/f2fs.txt
> +++ b/Documentation/filesystems/f2fs.txt
> @@ -216,7 +216,7 @@ The dump.f2fs shows the information of specific inode and dumps SSA and SIT to
>  file. Each file is dump_ssa and dump_sit.
>  
>  The dump.f2fs is used to debug on-disk data structures of the f2fs filesystem.
> -It shows on-disk inode information reconized by a given inode number, and is
> +It shows on-disk inode information recognized by a given inode number, and is
>  able to dump all the SSA and SIT entries into predefined files, ./dump_ssa and
>  ./dump_sit respectively.
>  
> diff --git a/Documentation/filesystems/nfs/Exporting b/Documentation/filesystems/nfs/Exporting
> index 09994c2..e543b1a 100644
> --- a/Documentation/filesystems/nfs/Exporting
> +++ b/Documentation/filesystems/nfs/Exporting
> @@ -93,7 +93,7 @@ For a filesystem to be exportable it must:
>     2/ make sure that d_splice_alias is used rather than d_add
>        when ->lookup finds an inode for a given parent and name.
>  
> -      If inode is NULL, d_splice_alias(inode, dentry) is eqivalent to
> +      If inode is NULL, d_splice_alias(inode, dentry) is equivalent to
>  
>  		d_add(dentry, inode), NULL
>  
> diff --git a/Documentation/filesystems/qnx6.txt b/Documentation/filesystems/qnx6.txt
> index 99e9018..4086797 100644
> --- a/Documentation/filesystems/qnx6.txt
> +++ b/Documentation/filesystems/qnx6.txt
> @@ -149,7 +149,7 @@ Bitmap system area
>  ------------------
>  
>  The bitmap itself is divided into three parts.
> -First the system area, that is split into two halfs.
> +First the system area, that is split into two halves.
>  Then userspace.
>  
>  The requirement for a static, fixed preallocated system area comes from how
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 12525b1..5be51fd 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -135,7 +135,7 @@ default behaviour.
>  	If the memory cost of 8 log buffers is too high on small
>  	systems, then it may be reduced at some cost to performance
>  	on metadata intensive workloads. The logbsize option below
> -	controls the size of each buffer and so is also relevent to
> +	controls the size of each buffer and so is also relevant to
>  	this case.
>  
>    logbsize=value
> 


-- 
~Randy
