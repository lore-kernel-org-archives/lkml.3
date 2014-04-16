Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbaDPR0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:26:53 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:52945 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaDPR0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:26:48 -0400
Date: Wed, 16 Apr 2014 13:26:44 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: gregkh@linuxfoundation.org, lizefan@huawei.com,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH] kernfs: move the last knowledge of sysfs out from kernfs
Message-ID: <20140416172644.GM1257@htj.dyndns.org>
References: <1397669058-31720-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397669058-31720-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 01:24:18AM +0800, Jianyu Zhan wrote:
> On Thu, Apr 17, 2014 at 12:46 AM, Tejun Heo <tj@kernel.org> wrote:
> > Please put it before @new_sb_created.
> 
> Ok.
> 
> > Also, why isn't it unsigned long magic?
> 
> I just thought there may be more private data in the future, so I made
> it a void pointer. But now I think this is overskill and meaningless.
> 
> Renewed patch here:
> 
> There is still one residue of sysfs remaining: the sb_magic
> SYSFS_MAGIC. However this should be kernfs user specific,
> so this patch moves it out. Kerrnfs user should specify their
> magic number while mouting.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
