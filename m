Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab3BST14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:27:56 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:53100 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab3BST1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:27:55 -0500
Date: Tue, 19 Feb 2013 11:27:50 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 13/15] workqueue: also record worker in work->data if
 running&&queued
Message-ID: <20130219192750.GT17414@htj.dyndns.org>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
 <1361203940-6300-14-git-send-email-laijs@cn.fujitsu.com>
 <20130218195023.GJ17414@htj.dyndns.org>
 <CACvQF52DsDXopHEdDAy42nY78+O6sr3RUd3s3Ehsd1Per6ms7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF52DsDXopHEdDAy42nY78+O6sr3RUd3s3Ehsd1Per6ms7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Tue, Feb 19, 2013 at 11:04:31PM +0800, Lai Jiangshan wrote:
> (But are patch 1, 5-8 possible merged after rebased and revised?)

0001 is problematic because it adds a hash lookup which isn't
necessary.  In this series, it's okay as the later lookup is removed
eventually but without that, I don't think it's a good idea to apply
0001.

0002 looks good to me.

0005, I'm not sure what the benefit would be without later changes.

0006-0008 yeah, probably.

I'll try to apply them on top of wq/for-3.9.

Thanks.

-- 
tejun
