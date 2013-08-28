Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3H1BQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 21:16:05 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41792 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3H1BQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 21:16:04 -0400
Date: Tue, 27 Aug 2013 18:11:23 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] power: max8925: fix missing of_node_put
Message-ID: <20130828011123.GA10506@lizard>
References: <521AFE7C.9020102@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <521AFE7C.9020102@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 03:06:36PM +0800, Libo Chen wrote:
> 
> decrease np device_node refcount after task completion
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

Applied, thanks!

Anton
