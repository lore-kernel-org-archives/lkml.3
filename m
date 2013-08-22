Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3HVO7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:59:35 -0400
Received: from relay.parallels.com ([195.214.232.42]:37804 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3HVO7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:59:32 -0400
Message-ID: <521627B6.6080603@parallels.com>
Date: Thu, 22 Aug 2013 19:01:10 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <riel@redhat.com>,
        <jack@suse.cz>, <dev@parallels.com>, <miklos@szeredi.hu>,
        <fuse-devel@lists.sourceforge.net>, <xemul@parallels.com>,
        <linux-kernel@vger.kernel.org>, <jbottomley@parallels.com>,
        <linux-mm@kvack.org>, <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <devel@openvz.org>, <mgorman@suse.de>
Subject: Re: [PATCH] mm: strictlimit feature -v4
References: <20130821135427.20334.79477.stgit@maximpc.sw.ru> <20130821133804.87ca602dd864df712e67342a@linux-foundation.org> <5215E4B7.3020003@parallels.com> <20130822144121.GA620@localhost>
In-Reply-To: <20130822144121.GA620@localhost>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

08/22/2013 06:41 PM, Fengguang Wu пишет:
> Hi Maxim,
>
>>> I think I'll apply it to -mm for now to get a bit of testing, but would
>>> very much like it if Fengguang could find time to review the
>>> implementation, please.
>> Great! Fengguang, please...
> I'm so sorry for the delays!
>
> I'd like to test the patches out and take a look at its runtime
> behaviors. I've managed to setup general dd writeback tests. Do you
> happen to have some scripts that can specifically test out the fuse
> cases?

I used ordinary dd over fuse mount for testing. But fuse setup was 
tricky. I'll send a writeup of my test environment to you tomorrow.

Thanks,
Maxim
