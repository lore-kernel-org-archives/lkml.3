Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935183Ab3DHSBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:01:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273Ab3DHSBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:01:06 -0400
Date: Mon, 8 Apr 2013 14:00:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        lpoetter@redhat.com, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org, dhaval.giani@gmail.com,
        workman-devel@redhat.com
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Message-ID: <20130408180056.GF28292@redhat.com>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <5162CA21.4060108@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5162CA21.4060108@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 05:46:09PM +0400, Glauber Costa wrote:

[..]
> The cpu cgroup needs a real-time timeslice to accept real time tasks. It
> defaults to 0, meaning that a newly created cpu cgroup cannot accept
> tasks (rt tasks) without the user having to manually configure it.
> As far as I know, this problem hasn't yet been fixed.

Yes, systemd folks wanted this to be fixed so that out of the box they
could put individual user session in a cgroup and still expect that 
any RT applications of user are not broken.

Thanks
Vivek
