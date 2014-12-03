Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852AbaLCAP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:15:57 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:57176 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933471AbaLCAPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:15:55 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Srikanth Thokala <sriku.linux@gmail.com>,
        linux-doc@vger.kernel.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: memory-barriers: Fix typo in the first example
References: <1416285598-6630-1-git-send-email-sriku.linux@gmail.com>
	<CA+mB=1+4=eG6d-99+yZ6HgpqvU2uan+-13pXt1=H+GZ0HeRL1A@mail.gmail.com>
	<20141202161519.581ea1af@lwn.net>
	<20141202215006.GT25340@linux.vnet.ibm.com>
	<20141202170136.7fb6f6a0@lwn.net>
	<20141202220935.GW25340@linux.vnet.ibm.com>
Date: Wed, 03 Dec 2014 00:15:50 +0000
In-Reply-To: <20141202220935.GW25340@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Tue, 2 Dec 2014 14:09:35 -0800")
Message-ID: <yw1x7fy9egg9.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> On Tue, Dec 02, 2014 at 05:01:36PM -0500, Jonathan Corbet wrote:
>> On Tue, 2 Dec 2014 13:50:06 -0800
>> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>> 
>> > I am guessing that this patch is against an old version of this file
>> > (there have been two patches applied to this example in the last six
>> > months).  I believe that the current version is correct, in other words,
>> > that Alexey Dobriyan and Pranith Kumar beat you to this one.  ;-)
>> 
>> I thought it looked familiar somehow...patch dropped.
>> 
>> I guess it's comforting to know that so many people are reading that file
>> so closely, but it's a little scary too...:)
>
> What scares me is that so few people appear to have been reading it
> earlier on.  ;-)

Or they read it but failed to understand it.  Not sure which is scarier.

Those are probably the Evil Vendor Tree developers who apparently think
"this is hard, best put volatile and barriers _everywhere_ and hope for
the best."

-- 
Måns Rullgård
mans@mansr.com
