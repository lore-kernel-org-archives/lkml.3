Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab3CLVAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:00:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59954 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542Ab3CLVAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:00:39 -0400
Date: Tue, 12 Mar 2013 14:00:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] async: simple cleanups
Message-ID: <20130312210034.GI25266@htj.dyndns.org>
References: <1363019405-4331-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363019405-4331-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 12:30:01AM +0800, Lai Jiangshan wrote:
> I found somethings need to be cleanup when I watch what has been changed
> to async.c.
> 
> Lai Jiangshan (3):
>   async: simplify lowest_in_progress()
>   async: remove unused @node from struct async_domain
>   async: rename and redefine async_func_ptr

Applied with cosmetic whitespace adjustments (why change the
formatting in the second patch?  For the 80 col limit?)

Thanks.

-- 
tejun
