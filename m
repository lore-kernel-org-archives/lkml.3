Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab3EBBeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:34:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31936 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab3EBBe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:34:29 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=eYoCjWX1dicA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=t0pOWasqti8A:10 a=07d9gI8wAAAA:8 a=TgWImvppX3oZUmv7Q7oA:9 a=CjuIK1q_8ugA:10 a=lCUxwSMheuoA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Wed, 1 May 2013 21:34:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        sonnyrao@chromium.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: IO regression after ab8fabd46f on x86 kernels with high memory
Message-ID: <20130502013426.GC9583@home.goodmis.org>
References: <517B1153.8000401@valvesoftware.com>
 <517B2FB4.30605@redhat.com>
 <20130427024248.GA1229@cmpxchg.org>
 <517EEBD1.503@valvesoftware.com>
 <CA+55aFxcq44JsrrR5KKuT=DZQHCfOE3KHQrcD215T+deYesW2g@mail.gmail.com>
 <517F14D1.3070307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517F14D1.3070307@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 08:48:17PM -0400, Rik van Riel wrote:
> 
> It could also print out a friendly message, to
> inform the user they should upgrade to a 64 bit
> kernel to enjoy the use of all of their memory.

Oh, oh, oh!!! Can we use my message:

  http://lwn.net/Articles/501769/

OK, maybe it's not so friendly ;-)

-- Steve

