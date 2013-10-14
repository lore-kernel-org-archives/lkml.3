Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab3JNUvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:51:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40675 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674Ab3JNUvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:51:36 -0400
Message-ID: <525C593D.4080607@infradead.org>
Date: Mon, 14 Oct 2013 13:51:09 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Mark Brown <broonie@kernel.org>, ceph-devel@vger.kernel.org,
        Sage Weil <sage@inktank.com>
Subject: Re: linux-next: Tree for Oct 14 (ceph)
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1381762088-18880-1-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/13 07:48, Thierry Reding wrote:
> Hi all,
> 
> I've uploaded today's linux-next tree to the master branch of the
> repository below:
> 
>         git://gitorious.org/thierryreding/linux-next.git
> 
> A next-20131014 tag is also provided for convenience.
> 
> Gained a few conflicts, but nothing too exciting. x86 and ARM default
> configurations build fine. There were some build failures unrelated to
> the merge, most of which I fixed and added as patches on top of the
> final merge.

on i386:

fs/ceph/file.c: In function 'ceph_sync_read':
fs/ceph/file.c:437:25: error: 'struct iov_iter' has no member named 'iov'
fs/ceph/file.c:438:18: error: 'struct iov_iter' has no member named 'iov'
fs/ceph/file.c:470:26: error: 'struct iov_iter' has no member named 'iov'
fs/ceph/file.c:472:9: error: 'struct iov_iter' has no member named 'iov'
fs/ceph/file.c:472:9: error: 'struct iov_iter' has no member named 'iov'
fs/ceph/file.c:472:9: warning: comparison of distinct pointer types lacks a cast [enabled by default]
fs/ceph/file.c: In function 'ceph_sync_direct_write':
fs/ceph/file.c:586:24: error: 'struct iov_iter' has no member named 'iov'
fs/ceph/file.c:587:14: error: 'struct iov_iter' has no member named 'iov'
fs/ceph/file.c: In function 'ceph_sync_write':
fs/ceph/file.c:737:18: warning: comparison of distinct pointer types lacks a cast [enabled by default]




-- 
~Randy
