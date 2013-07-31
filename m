Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681Ab3GaLjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:39:18 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:65071 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759664Ab3GaLjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:39:16 -0400
Date: Wed, 31 Jul 2013 07:39:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 7/7] cgroup: more naming cleanups
Message-ID: <20130731113912.GN2810@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C85C.1050206@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F8C85C.1050206@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 04:18:36PM +0800, Li Zefan wrote:
> Constantly use @cset for css_set varabbles and use @cgrp as cgroup
> variables.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
