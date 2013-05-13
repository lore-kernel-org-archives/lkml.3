Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3EMOyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:54:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab3EMOyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:54:43 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Mel Gorman <mgorman@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, Lin Feng <linfeng@cn.fujitsu.com>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, zab@redhat.com,
        linux-mm@kvack.org, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH V2 1/2] mm: hotplug: implement non-movable version of get_user_pages() called get_user_pages_non_movable()
References: <1360056113-14294-1-git-send-email-linfeng@cn.fujitsu.com>
	<1360056113-14294-2-git-send-email-linfeng@cn.fujitsu.com>
	<20130205120137.GG21389@suse.de> <20130206004234.GD11197@blaptop>
	<20130206095617.GN21389@suse.de> <5190AE4F.4000103@cn.fujitsu.com>
	<20130513091902.GP11497@suse.de> <20130513143757.GP31899@kvack.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 13 May 2013 10:54:03 -0400
In-Reply-To: <20130513143757.GP31899@kvack.org> (Benjamin LaHaise's message of
	"Mon, 13 May 2013 10:37:57 -0400")
Message-ID: <x49obcfnd6c.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise <bcrl@kvack.org> writes:

> On Mon, May 13, 2013 at 10:19:02AM +0100, Mel Gorman wrote:
>> On Mon, May 13, 2013 at 05:11:43PM +0800, Tang Chen wrote:
> ...
>> > If so, I'm wondering where should we put this callback pointers ?
>> > In struct page ?
>> > 
>> 
>> No, I would expect the callbacks to be part the address space operations
>> which can be found via page->mapping.
>
> If someone adds those callbacks and provides a means for testing them, 
> it would be pretty trivial to change the aio code to migrate its pinned 
> pages on demand.

How do you propose to move the ring pages?

Cheers,
Jeff
