Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbaBFSzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:55:09 -0500
Received: from service87.mimecast.com ([91.220.42.44]:47806 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbaBFSzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:55:06 -0500
Message-ID: <52F3DA85.1060209@arm.com>
Date: Thu, 06 Feb 2014 18:55:01 +0000
From: Ramana Radhakrishnan <ramrad01@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
References: <20140206134825.305510953@infradead.org> <21984.1391711149@warthog.procyon.org.uk>
In-Reply-To: <21984.1391711149@warthog.procyon.org.uk>
X-OriginalArrivalTime: 06 Feb 2014 18:55:01.0805 (UTC) FILETIME=[F0A885D0:01CF236C]
X-MC-Unique: 114020618550303001
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/14 18:25, David Howells wrote:
>
> Is it worth considering a move towards using C11 atomics and barriers and
> compiler intrinsics inside the kernel?  The compiler _ought_ to be able to do
> these.


It sounds interesting to me, if we can make it work properly and 
reliably. + gcc@gcc.gnu.org for others in the GCC community to chip in.

>
> One thing I'm not sure of, though, is how well gcc's atomics will cope with
> interrupt handlers touching atomics on CPUs without suitable atomic
> instructions - that said, userspace does have to deal with signals getting
> underfoot. but then userspace can't normally disable interrupts.
>
> David
>

Ramana

