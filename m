Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab3J1HXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 03:23:30 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:37427 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab3J1HX3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Mon, 28 Oct 2013 03:23:29 -0400
Message-Id: <526E1EFA02000078000FD1E7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 28 Oct 2013 07:23:22 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@kernel.org>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, <mingo@elte.hu>,
        <tglx@linutronix.de>, "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <arjan@linux.intel.com>, <linux@roeck-us.net>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: unify copy_from_user() size checking
References: <5265056D02000078000FC4F3@nat28.tlf.novell.com>
 <20131026103109.GC14949@gmail.com>
In-Reply-To: <20131026103109.GC14949@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.10.13 at 12:31, Ingo Molnar <mingo@kernel.org> wrote:
> * Jan Beulich <JBeulich@suse.com> wrote:
>> I'd like to point out though that with __compiletime_object_size()
>> being restricted to gcc before 4.6, the whole construct is going to
>> become more and more pointless going forward. I would question
>> however that commit 2fb0815c9ee6b9ac50e15dd8360ec76d9fa46a2 ("gcc4:
>> disable __compiletime_object_size for GCC 4.6+") was really necessary,
>> and instead this should have been dealt with as is done here from the
>> beginning.
> 
> Can we now revert 2fb0815c9ee6?

Afaict yes, but I certainly didn't test with all possible gcc versions.
So minimally everyone involved in getting that change in would be
good to be in agreement.

Jan

