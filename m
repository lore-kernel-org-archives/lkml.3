Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3J0Lja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 07:39:30 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:60258 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3J0Lj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 07:39:28 -0400
Date: Sun, 27 Oct 2013 07:39:25 -0400
From: Tejun Heo <tj@kernel.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cgroups: remove calls to simple_kstrtoll
Message-ID: <20131027113925.GF14934@mtj.dyndns.org>
References: <1382754793-8827-3-git-send-email-dwalker@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382754793-8827-3-git-send-email-dwalker@fifo99.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 07:33:13PM -0700, Daniel Walker wrote:
> Signed-off-by: Daniel Walker <dwalker@fifo99.com>

Can you please briefly explain why this conversion is happening in the
patch description?

Thanks.

-- 
tejun
