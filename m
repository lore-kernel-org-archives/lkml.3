Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936435Ab3DRRD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:03:29 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:43010 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936055Ab3DRRD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:03:26 -0400
Date: Thu, 18 Apr 2013 10:03:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        dm-crypt@saout.de, Christian Schmidt <schmidt@digadd.de>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Milan Broz <gmazyland@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
Message-ID: <20130418170317.GA9897@mtj.dyndns.org>
References: <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
 <20130410235009.GI17641@mtj.dyndns.org>
 <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
 <20130411195203.GA11956@mtj.dyndns.org>
 <20130411200005.GB11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304121340350.3359@file.rdu.redhat.com>
 <20130412182941.GF11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304150827480.1859@file.rdu.redhat.com>
 <20130416172418.GB2874@mtj.dyndns.org>
 <20130418164742.GA8254@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418164742.GA8254@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mike.

On Thu, Apr 18, 2013 at 12:47:42PM -0400, Mike Snitzer wrote:
> I see you nack and raise you with: please reconsider in the near term.

The thing is that percpu-refcnting is already in mostly ready-form, so
unless this dm series is planned to be merged for v3.10-rc1, I don't
see the need for a separate near term solution.  Mikulas can just do
the normal refcnting and cgroup will most likely adopt per-cpu ref
anyway once percpu-refcnting is in, so it should all fall in places
pretty quickly.  For devel / testing / whatever, Mikulas can surely
turn off cgroup, right?

Thanks.

-- 
tejun
