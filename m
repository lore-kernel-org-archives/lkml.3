Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3LLSvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:51:53 -0500
Received: from relay.parallels.com ([195.214.232.42]:34221 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3LLSvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:51:50 -0500
Message-ID: <52AA05C1.1070709@parallels.com>
Date: Thu, 12 Dec 2013 22:51:45 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] cgroup: fix fail path in cgroup_load_subsys()
References: <1386403085-24866-1-git-send-email-vdavydov@parallels.com> <20131212153536.GD32683@htj.dyndns.org> <20131212155523.GF32683@htj.dyndns.org> <52AA026C.3040605@parallels.com> <20131212184506.GK32683@htj.dyndns.org>
In-Reply-To: <20131212184506.GK32683@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.24.25.135]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 10:45 PM, Tejun Heo wrote:
> Hello,
>
> On Thu, Dec 12, 2013 at 10:37:32PM +0400, Vladimir Davydov wrote:
>> If so, I don't mind, but why? cgroup_unload_subsys() should never be
>> called without properly initialized css.
> Hmm.... I think it's generally preferable to reuse normal exit path
> for error handling as much as possible.  Plus, the normal cgroup init
> failure path behaves that way.  That said, it's more of a preference
> and if you have technical argument, I'd be happy to give in. :)

Got it, will do.

Thanks.
