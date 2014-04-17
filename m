Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbaDQNTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:19:24 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:44021 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbaDQNTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:19:22 -0400
Date: Thu, 17 Apr 2014 09:19:18 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs: fix a subdir count leak
Message-ID: <20140417131918.GI26632@htj.dyndns.org>
References: <1397728330-11099-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397728330-11099-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 05:52:10PM +0800, Jianyu Zhan wrote:
> Currently kernfs_link_sibling() increates parent->dir.subdirs before
> adding the node into parent's chidren rb tree.
> 
> Because it is possible that kernfs_link_sibling() couldn't find
> a suitable slot and bail out, this leads to a mismatch between
> elevated subdir count with actual children node numbers.
> 
> This patches fix this problem, by moving the subdir accouting
> after the actual addtion happening.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
