Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbaLJO3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:29:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944AbaLJO3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:29:06 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v12 00/20] DAX: Page cache bypass for filesystems on memory storage
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
	<20141210140347.GA23252@infradead.org> <20141210141211.GD2220@wil.cx>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 10 Dec 2014 09:28:33 -0500
In-Reply-To: <20141210141211.GD2220@wil.cx> (Matthew Wilcox's message of "Wed,
	10 Dec 2014 09:12:11 -0500")
Message-ID: <x49388ntw8e.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox <willy@linux.intel.com> writes:

> On Wed, Dec 10, 2014 at 06:03:47AM -0800, Christoph Hellwig wrote:
>> What is the status of this patch set?
>
> I have no outstanding bug reports against it.  Linus told me that he
> wants to see it come through Andrew's tree.  I have an email two weeks
> ago from Andrew saying that it's on his list.  I would love to see it
> merged since it's almost a year old at this point.

I'd also like to see this go in soon.
