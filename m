Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaDPQqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:46:15 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:36587 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaDPQqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:46:11 -0400
Date: Wed, 16 Apr 2014 12:46:07 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: gregkh@linuxfoundation.org, lizefan@huawei.com,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH] kernfs: move the last knowledge of sysfs out from kernfs
Message-ID: <20140416164607.GJ1257@htj.dyndns.org>
References: <1397666401-10427-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397666401-10427-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 17, 2014 at 12:40:01AM +0800, Jianyu Zhan wrote:
> @@ -132,6 +132,7 @@ const void *kernfs_super_ns(struct super_block *sb)
>   * @flags: mount flags specified for the mount
>   * @root: kernfs_root of the hierarchy being mounted
>   * @new_sb_created: tell the caller if we allocated a new superblock
> + * @private: any file system specifc private data

Please put it before @new_sb_created.  Also, why isn't it unsigned
long magic?

Thanks.

-- 
tejun
