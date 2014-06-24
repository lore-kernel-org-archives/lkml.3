Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbaFXU6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:58:38 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:46716 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbaFXU6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:58:35 -0400
Date: Tue, 24 Jun 2014 16:58:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: David Rientjes <rientjes@google.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Cgroups <cgroups@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy: fix sleeping function called from invalid
 context
Message-ID: <20140624205832.GB14909@htj.dyndns.org>
References: <53902A44.50005@cn.fujitsu.com>
 <20140605132339.ddf6df4a0cf5c14d17eb8691@linux-foundation.org>
 <539192F1.7050308@cn.fujitsu.com>
 <alpine.DEB.2.02.1406081539140.21744@chino.kir.corp.google.com>
 <539574F1.2060701@cn.fujitsu.com>
 <alpine.DEB.2.02.1406090209460.24247@chino.kir.corp.google.com>
 <53967465.7070908@huawei.com>
 <20140620210137.GA2059@mtj.dyndns.org>
 <53A8E23C.4050103@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A8E23C.4050103@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 24, 2014 at 10:28:12AM +0800, Li Zefan wrote:
> > I don't think the suggested patch breaks anything more than it was
> > broken before and we should probably apply it for the time being.  Li?
> 
> Yeah, we should apply Gu Zheng's patch any way.

Gu Zheng, can you please respin the patch with updated explanation on
the temporary nature of the change.  I'll apply it once Li acks it.

Thanks.

-- 
tejun
