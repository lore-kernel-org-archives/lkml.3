Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab3JONeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:34:17 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:32848 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585Ab3JONeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:34:15 -0400
Date: Tue, 15 Oct 2013 09:34:10 -0400
From: Tejun Heo <tj@kernel.org>
To: anjana vk <anjanvk12@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        eunki_kim@samsung.com
Subject: Re: cgroup_attach_task && while_each_thread (Was: cgroup attach task
 - slogging cpu)
Message-ID: <20131015133410.GE3141@htj.dyndns.org>
References: <20131004130207.GA9338@redhat.com>
 <20131007184507.GD27396@htj.dyndns.org>
 <20131008145833.GA15600@redhat.com>
 <5254EB2A.7090803@huawei.com>
 <20131009133047.GA12414@redhat.com>
 <20131009140551.GA15849@redhat.com>
 <20131009165448.GA22437@redhat.com>
 <5257F9E3.5030708@huawei.com>
 <20131011160004.GA26416@redhat.com>
 <CALPf4Ty_xmred_Mf=tyzKDLu+rqStYUxTazZpYDOCKN_nm-5vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALPf4Ty_xmred_Mf=tyzKDLu+rqStYUxTazZpYDOCKN_nm-5vQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 10:34:04AM +0530, anjana vk wrote:
> Hi All,
> 
> Thankyou for your suggestions.
> I have made the modifications as suggested.

I already applied the version Li posted (as you the author, of course).

Thanks a lot!

-- 
tejun
