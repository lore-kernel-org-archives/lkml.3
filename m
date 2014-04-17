Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaDQJR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:17:56 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:65524 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaDQJR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:17:28 -0400
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: Michal Marek <michal.marek@matfyz.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH] .gitignore: ignore Module.symvers in all directories
References: <415f152dbdb6d675ebca57afd8bfbc785a70cfd1.1397458539.git.gamerh2o@gmail.com>
	<20140416210826.GA20810@fiji.localdomain>
Date: Thu, 17 Apr 2014 17:17:16 +0800
In-Reply-To: <20140416210826.GA20810@fiji.localdomain> (Michal Marek's message
	of "Wed, 16 Apr 2014 23:08:26 +0200")
Message-ID: <87eh0wz55v.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 23:08:26 +0200, Michal Marek wrote:
> On Mon, Apr 14, 2014 at 02:56:15PM +0800, Zhao, Gang wrote:
>> When using `make M=/path/to/driver modules` to build a module, file
>> Module.symvers will be created in that directory, so it's better to
>> ignore it in all directories.
>> 
>> Slightly reordered, let specific file names behind general ones.
>> 
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Kyungsik Lee <kyungsik.lee@lge.com>
>> Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
>> Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
>
> Note that the easier way to build a subtree of the kernel source is
>
>   make path/to/driver/
>
Thanks for pointing out this.

> including the trailing /. But the M=... syntax seems so widespread that
> I have to apply this.
>
The M=... syntax is the first I learned to build a module. I think it's
popular because one can build out of tree drivers by using it(adding
C=...). As you said, it's better to use `make path/to/driver/` to build
in-tree drivers.

> BTW: there is really no need to CC the last N people who touched
> such a trivial file :).
>
./scripts/get_maintainer.pl doesn't return the maintainer of this
file. Maybe you can add this file to MAINTAINERS(telling you are the
maintainer), but it's really so trivial. :-)

> Michal
