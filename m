Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3J3DHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 23:07:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42251 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751948Ab3J3DHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 23:07:46 -0400
Message-ID: <52707800.9020009@free-electrons.com>
Date: Wed, 30 Oct 2013 04:07:44 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Joe Perches <joe@perches.com>, yann.morin.1998@free.fr,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checkkconfig.py: find unused Kconfig parameters
References: <1382592209-10246-1-git-send-email-michael.opdenacker@free-electrons.com> <1382599849.22433.51.camel@joe-AO722> <526A746C.3060806@free-electrons.com> <526A75E7.30109@suse.cz>
In-Reply-To: <526A75E7.30109@suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Thank you very much for your reviews!

On 10/25/2013 03:45 PM, Michal Marek wrote:

> You can process Kconfig files and source files separately. And you can
> speed up the script a lot, if you simply record all CONFIG_* strings
> found in the sources, and then compare this to the set of config options
> defined in Kconfig. Then you can also easily implement the opposite
> check, which is currently done by scripts/checkkconfigsymbols.sh.
I like the idea. CONFIG_* strings at least should be easy to identify in
the source code indeed. I'll also have to find all the parameters
referred to in Kconfig files (namely as dependencies), but this should
be worth the effort.

The whole program will be a bit more complex, but it will be orders of
magnitude faster!

Thanks again,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

