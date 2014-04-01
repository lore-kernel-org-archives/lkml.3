Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaDAC1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 22:27:32 -0400
Received: from imap.thunk.org ([74.207.234.97]:48070 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbaDAC1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 22:27:30 -0400
Date: Mon, 31 Mar 2014 22:27:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Venkatesh Srinivas <venkateshs@google.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-blk: make the queue depth the max supportable by
 the hypervisor
Message-ID: <20140401022708.GD4911@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Venkatesh Srinivas <venkateshs@google.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux-foundation.org
References: <1394841445-16142-1-git-send-email-venkateshs@google.com>
 <1394854471-25700-1-git-send-email-tytso@mit.edu>
 <87siqhu048.fsf@rustcorp.com.au>
 <20140317054053.GF14162@thunk.org>
 <871txysnw2.fsf@rustcorp.com.au>
 <CAHdzE-_cAndCNhBM1N0RpjQDhoh3Snas-eza4rYN33Rf69PXyw@mail.gmail.com>
 <CAHdzE--CvgsPOFQ5OFRoe7L+kkJ0J3eRWR0JQv34i4AmNDBJug@mail.gmail.com>
 <87ha6fowh9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ha6fowh9.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 02:22:50PM +1030, Rusty Russell wrote:
> 
> It's head of my virtio-next tree.

Hey Rusty,

While we have your attention --- what's your opinion about adding TRIM
support to virtio-blk.  I understand that you're starting an OASIS
standardization process for virtio --- what does that mean vis-a-vis a
patch to plumb discard support through virtio-blk?

Thanks!

						- Ted
