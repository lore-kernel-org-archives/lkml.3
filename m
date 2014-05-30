Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571AbaE3V4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 17:56:38 -0400
Received: from srv01.voixit.com ([78.47.68.188]:37905 "EHLO srv01.voixit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbaE3V4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 17:56:35 -0400
Subject: Re: [PATCH RFC - TAKE TWO - 02/12] block, bfq: add full hierarchical scheduling and cgroups support
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=us-ascii
From: Paolo Valente <paolo.valente@unimore.it>
In-Reply-To: <20140530153943.GC24871@htj.dyndns.org>
Date: Fri, 30 May 2014 23:49:24 +0200
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1AE5EFA9-79A1-418A-8EF1-55764B8AA3BA@unimore.it>
References: <20140528221929.GG1419@htj.dyndns.org> <1401354343-5527-1-git-send-email-paolo.valente@unimore.it> <1401354343-5527-3-git-send-email-paolo.valente@unimore.it> <20140530153718.GB24871@htj.dyndns.org> <20140530153943.GC24871@htj.dyndns.org>
To: Tejun Heo <tj@kernel.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Il giorno 30/mag/2014, alle ore 17:39, Tejun Heo <tj@kernel.org> ha scritto:

> On Fri, May 30, 2014 at 11:37:18AM -0400, Tejun Heo wrote:
>> On Thu, May 29, 2014 at 11:05:33AM +0200, Paolo Valente wrote:
>>> diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
>>> index 768fe44..cdd2528 100644
>>> --- a/include/linux/cgroup_subsys.h
>>> +++ b/include/linux/cgroup_subsys.h
>>> @@ -39,6 +39,10 @@ SUBSYS(net_cls)
>>> SUBSYS(blkio)
>>> #endif
>>> 
>>> +#if IS_ENABLED(CONFIG_CGROUP_BFQIO)
>>> +SUBSYS(bfqio)
>>> +#endif
>> 
>> So, ummm, I don't think this is a good idea.  Why aren't you plugging
>> into the blkcg infrastructure as cfq does?  Why does it need to be a
>> separate controller?
> 
> If there's something which doesn't work for bfq in blkcg, please let
> me know.  I'd be happy to make it work.
> 

This will probably be very useful for us.

Thanks a lot,
Paolo

> Thanks.
> 
> -- 
> tejun


--
Paolo Valente                                                 
Algogroup
Dipartimento di Fisica, Informatica e Matematica		
Via Campi, 213/B
41125 Modena - Italy        				  
homepage:  http://algogroup.unimore.it/people/paolo/

