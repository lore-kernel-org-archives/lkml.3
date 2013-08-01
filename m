Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3HAMJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:09:01 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:48108 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab3HAMJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:09:00 -0400
Date: Thu, 1 Aug 2013 08:08:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] cgroup: remove struct cgroup_seqfile_state
Message-ID: <20130801120855.GA24966@htj.dyndns.org>
References: <51F8DA99.3010303@huawei.com>
 <20130731113619.GL2810@htj.dyndns.org>
 <51F9B5BD.2070502@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F9B5BD.2070502@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 09:11:25AM +0800, Li Zefan wrote:
> On 2013/7/31 19:36, Tejun Heo wrote:
> > On Wed, Jul 31, 2013 at 05:36:25PM +0800, Li Zefan wrote:
> >> We can use struct cfent instead.
> >>
> >> v2:
> >> - remove cgroup_seqfile_release().
> >>
> >> Signed-off-by: Li Zefan <lizefan@huawei.com>
> > 
> > Applied to libata/for-3.12.
> > 
> 
> libata? I hope you didn't. :)

Haha, brainfart.  I did apply it to cgroup/for-3.12. :)

-- 
tejun
