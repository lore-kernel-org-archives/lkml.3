Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3L0QsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 11:48:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60877 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3L0QsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 11:48:01 -0500
Message-ID: <52BDAF3D.2040803@infradead.org>
Date: Fri, 27 Dec 2013 08:47:57 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 1/1] filesystems: Update 00-INDEX in Documentation/filesystems
References: <20131227104410.9e6c368ae9d6e0ea3d2a0a0d@skynet.be>
In-Reply-To: <20131227104410.9e6c368ae9d6e0ea3d2a0a0d@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc-ing doc. maintainer.

On 12/26/13 18:44, Fabian Frederick wrote:
> Add the following documentation-files with description :
>  -autofs4-mount-control.txt
>  -btrfs.txt
>  -debugfs.txt
>  -devpts.txt
>  -fiemap.txt
>  -gfs2-glocks.txt
>  -gfs2-uevents.txt
>  -omfs.txt
>  -path-lookup.txt
>  -qnx6.txt
>  -quota.txt
>  -squashfs.txt
>  -sysfs-tagging.txt
>  -ubifs.txt
>  -xfs-delayed-logging-design.txt
>  -xfs-self-describing-metadata.txt
> 
> Add the following documentation directories with description :
>  -caching
>  -cifs (replacing cifs.txt)
>  -pohmelfs
> 
> Remove the following documentation-files reference:
>  -dentry-locking.txt
>  -reiser4.txt
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  Documentation/filesystems/00-INDEX | 58 +++++++++++++++++++++++++++++---------
>  1 file changed, 45 insertions(+), 13 deletions(-)


-- 
~Randy
