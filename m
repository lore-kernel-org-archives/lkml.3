Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbaHYOM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:12:26 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:35892 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbaHYOMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:12:24 -0400
Date: Mon, 25 Aug 2014 10:12:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] cgroup: Introduce cgroup_detach_task().
Message-ID: <20140825141220.GA31066@mtj.dyndns.org>
References: <1408966330-2374-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408966330-2374-1-git-send-email-yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 07:32:10PM +0800, Dongsheng Yang wrote:
> Currently, the only method to detach a task from a cgroup is moving
> it to others. It looks not natrual to me.

Ummm... how is this different from moving it to the root cgroup?
"just because" usually isn't a good enough rationale.

Thanks.

-- 
tejun
