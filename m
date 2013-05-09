Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3EIQb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 12:31:29 -0400
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:47575 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249Ab3EIQb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 12:31:28 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 May 2013 12:31:28 EDT
Date: Thu, 9 May 2013 16:25:00 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dave Hansen <dave@sr71.net>
cc: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/22] Per-cpu page allocator replacement prototype
In-Reply-To: <518BC3BD.30005@sr71.net>
Message-ID: <0000013e8a1c2415-a5cdffec-1de7-4814-ae75-0965a645edb2-000000@email.amazonses.com>
References: <1368028987-8369-1-git-send-email-mgorman@suse.de> <518BC3BD.30005@sr71.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.09-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 May 2013, Dave Hansen wrote:

> BTW, I really like the 'magazine' name.  It's not frequently used in
> this kind of context and it conjures up a nice mental image whether it
> be of stacks of periodicals or firearm ammunition clips.

The term "magazine" was prominently used in the Bonwick article that was
the base of the creation of the SLAB allocator.

http://static.usenix.org/event/usenix01/full_papers/bonwick/bonwick.pdf

http://static.usenix.org/publications/library/proceedings/bos94/full_papers/bonwick.a

