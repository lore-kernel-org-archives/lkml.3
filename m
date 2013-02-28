Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab3B1OYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:24:19 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:52676 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3B1OYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:24:18 -0500
Date: Thu, 28 Feb 2013 11:24:11 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        Dongsoo Nathaniel Kim <dongsoo.kim@gmail.com>
Subject: Re: [PATCH] perf kvm: fix segfault by initializing file_name to NULL
Message-ID: <20130228142411.GE2656@ghostprotocols.net>
References: <1362022197-38929-1-git-send-email-dsahern@gmail.com>
 <512EDD96.9090600@linux.vnet.ibm.com>
 <512EE073.8090709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512EE073.8090709@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 27, 2013 at 09:43:31PM -0700, David Ahern escreveu:
> On 2/27/13 9:31 PM, Xiao Guangrong wrote:
> >On 02/28/2013 11:29 AM, David Ahern wrote:
> >>Dongsoo reported that perf-kvm was segfaulting. The bug was introduced by
> >>commit 3786063 which moved file_name from struct perf_kvm which was
> >>initialized on the stack to an uninitialized stack variable. Fix by
> >>initializing.

> >>Needs to be applied to 3.7 and 3.8 as well.

> >David, The bug has already been fixed by by Arnaldo, see:
> >http://git.kernel.org/?p=virt/kvm/kvm.git;a=commit;h=20914ce5b9e1ef4a35f1f09a2c9c8fb8eb1c4d86

> very odd. Arnaldo's latest perf/urgent has the problem -- and no
> initialized variable. Seems to have been dropped somewhere.

Just fast forwarded my perf/urgent to tip/perf/urgent, checked and the
fix is there as pointed out by Xiao.

- Arnaldo
