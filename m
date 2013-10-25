Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab3JYJ2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:28:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3JYJ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:28:40 -0400
Date: Fri, 25 Oct 2013 02:29:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>, torvalds@linux-foundation.org,
        fengguang.wu@intel.com, linux-kernel@vger.kernel.org
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-Id: <20131025022937.12623dcd.akpm@linux-foundation.org>
In-Reply-To: <20131025091842.GA28681@thunk.org>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
	<CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
	<1814253454.3449.1382689853825.JavaMail.mail@webmail07>
	<20131025091842.GA28681@thunk.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Oct 2013 05:18:42 -0400 "Theodore Ts'o" <tytso@mit.edu> wrote:

> What I think would make sense is to dynamically measure the speed of
> writeback, so that we can set these limits as a function of the device
> speed.

We attempt to do this now - have a look through struct backing_dev_info.

Apparently all this stuff isn't working as desired (and perhaps as designed)
in this case.  Will take a look after a return to normalcy ;)
