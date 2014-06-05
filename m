Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaFEBUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:20:17 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:61164 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaFEBUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:20:15 -0400
Date: Wed, 4 Jun 2014 21:20:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] cgroup: make the default root invisible when it's
 umounted
Message-ID: <20140605012011.GB14370@mtj.dyndns.org>
References: <538D4956.5050205@huawei.com>
 <538D4982.10905@huawei.com>
 <20140603130144.GB26210@htj.dyndns.org>
 <538EE00F.10406@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538EE00F.10406@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 04, 2014 at 04:59:59PM +0800, Li Zefan wrote:
> The example I gave is the same result if sane_behavior is not specified,
> so this is a behavioural change for the old interface?

Hmmm?  Either the userland knows about unified hierarchy or not and
there's no point in hiding it if we know that userland knows.  It's
really a system-wide thing which happens once.

Thanks.

-- 
tejun
