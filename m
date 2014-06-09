Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbaFIXfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:35:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbaFIXfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 19:35:12 -0400
Date: Mon, 9 Jun 2014 19:34:59 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: rb_erase oops.
Message-ID: <20140609233459.GA26101@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
References: <20140609223028.GA13109@redhat.com>
 <CA+55aFw8MzKeNFPO+CgxyBcH-VZP4Q0Te+-Ue+r3-NNBjZ=mFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw8MzKeNFPO+CgxyBcH-VZP4Q0Te+-Ue+r3-NNBjZ=mFA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 04:30:21PM -0700, Linus Torvalds wrote:
 > On Mon, Jun 9, 2014 at 3:30 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > Oops: 0000 [#1] PREEMPT SMP
 > 
 > Dave, for some reason your oops is missing the first line. There
 > should have been something like
 > 
 >  "Unable to handle kernel NULL pointer access at 00000001"
 > 
 > or something.

For some reason, that line never made it over usb-serial.

[56274.041989] trinity-c22 (7025) used greatest stack depth: 9440 bytes left
[77373.915561] Oops: 0000 [#1] PREEMPT SMP

Weird.

	Dave

