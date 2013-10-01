Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3JAPpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:45:55 -0400
Received: from longford.logfs.org ([213.229.74.203]:57986 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab3JAPpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:45:53 -0400
Date: Tue, 1 Oct 2013 10:26:55 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the bcon tree
Message-ID: <20131001142655.GA29919@logfs.org>
References: <20131001110344.GA20249@ulmo.nvidia.com>
 <1380625644-11331-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380625644-11331-1-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 October 2013 13:07:17 +0200, Thierry Reding wrote:
> 
> Today's linux-next merge of the bcon tree got conflicts in:
> 
> 	drivers/block/Kconfig
> 	kernel/printk.c
> 
> I fixed them up (see below). Please check if the resolution looks correct.

I think for the moment you can drop the bcon tree.  I have plans to
get it merged into mainline eventually, but currently lack time to
spend on it.  In other words, it isn't really -next material.

Jörn

--
Doubt is not a pleasant condition, but certainty is an absurd one.
-- Voltaire
