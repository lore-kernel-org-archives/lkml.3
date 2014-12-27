Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaL0J1B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 04:27:01 -0500
Received: from ozlabs.org ([103.22.144.67]:35696 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbaL0J1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 04:27:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] virtio/vhost: fix alignment requirements
In-Reply-To: <20141225150548.GA12865@redhat.com>
References: <1419517332-12291-1-git-send-email-mst@redhat.com> <20141225150548.GA12865@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 27 Dec 2014 19:52:16 +1030
Message-ID: <87fvc1bg6v.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Thu, Dec 25, 2014 at 05:05:01PM +0200, Michael S. Tsirkin wrote:
>> vhost incorrectly asked for 8 byte alignment for
>> used ring pointer, it should be 4 byte.
>> 
>> Let's add explicit macros for ring element alignment,
>> this makes it easier to make sure our requirements
>> match the spec.
>> 
>> Rusty, OK to merge this through my vhost tree, or do you
>> prefer merging this through yours?
>
> Just to clarify, this is needed in 3.19.

Sure, please take this via the vhost tree.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
