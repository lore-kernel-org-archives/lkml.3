Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3GCMMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:12:21 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:43590 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3GCMMU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:12:20 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [PATCH 1/2] Fix a build warning in scripts/sortextable.h
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <51D41413.9060500@suse.cz>
Date: Wed, 3 Jul 2013 22:12:11 +1000
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, David Daney <david.daney@cavium.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <015BB7AD-78C4-4F1A-B65A-B37FBB6E2B9C@gmail.com>
References: <1370745235-12951-1-git-send-email-dt.tangr@gmail.com> <51D413D9.8040604@suse.cz> <51D41413.9060500@suse.cz>
To: Michal Marek <mmarek@suse.cz>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/07/2013, at 10:07 PM, Michal Marek <mmarek@suse.cz> wrote:

> On 3.7.2013 14:06, Michal Marek wrote:
>> Added David Daney to CC.
> 
> Second attempt, sorry.
> 
> 
>> On 9.6.2013 04:33, Daniel Tang wrote:
>>> The pointer passed to the _r() macro does not always match the type
>>> of the function that it is aliasing and raises several of the following
>>> warnings at compile time:
>>> 
>>> warning: passing argument 1 of ‘r8’ from incompatible pointer type
>> 
>> In what environment (arch, compiler, glibc) are you seeing this?
>> 

I'm cross compiling the ARM arch with gcc version 4.7.2 on 64 bit OS X. It should throw that warning on any 64 bit environment (not just OS X) but I haven't tested it.

If you want, I can look a little deeper into this.

Cheers,
tangrs