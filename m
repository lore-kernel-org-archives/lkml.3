Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3J0Mgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 08:36:53 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:63293 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab3J0Mgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 08:36:52 -0400
Date: Sun, 27 Oct 2013 08:36:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: cl@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] percpu: little optimization on calculating
 pcpu_unit_size
Message-ID: <20131027123634.GL14934@mtj.dyndns.org>
References: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <1382345893-6644-3-git-send-email-weiyang@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382345893-6644-3-git-send-email-weiyang@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 04:58:13PM +0800, Wei Yang wrote:
> pcpu_unit_size exactly equals to ai->unit_size.
> 
> This patch assign this value instead of calculating from pcpu_unit_pages. Also
> it reorder them to make it looks more friendly to audience.

Ditto.  I'd rather not change unless this is clearly better.

Thanks.

-- 
tejun
