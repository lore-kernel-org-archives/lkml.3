Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaHRHZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 03:25:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34178 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaHRHZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 03:25:22 -0400
Message-ID: <53F1AA61.3080808@infradead.org>
Date: Mon, 18 Aug 2014 00:25:21 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Markus Osterhoff <mo@mo-online.org>
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [TYPO 0/9] Several spellings and punctuations in Documentation
References: <20140817182956.GA4077@mo-online.de>
In-Reply-To: <20140817182956.GA4077@mo-online.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/14 11:29, Markus Osterhoff wrote:
> While reading some documentation to get acquainted with the Linux kernel
> development, I encountered some spelling and punctuation, erm, mutants
> that are addressed in this patch-set.
> 
> Patches are based on v3.17-rc1.
> 
> Since this is my first patch, any comments on style and email are
> welcome.

Hi Markus,

It would be nice (but not strictly required) for patches 1-9 to be
replies to (or references to) patch 0.
git-send-email can do this; see --thread.

> Markus Osterhoff (9):
>   [typo] spelling, punctuation in main README file
>   [typo] MAINTAINERS: redundant full stop removed
>   [typo] REPORTING-BUGS
>   [typo] COPYING: form feeds removed
>   [typo] CREDITS: capitalisation, punctuation
>   [typo] Doc/kbuild/kconfig-language.txt: several spellings
>   [typo] Doc/kbuild/kconfig-language.txt: sentence structure
>   [typo] Doc/CodingStyle, BUG-HUNTING, 00-INDEX
>   [typo] spelling, punctuation in Documentation/...

Patches should have a Subject: like
[PATCH 1/9] README: fix spelling and punctuation in main README file

I would prefer for these to all go thru the trivial patch maintainer:
Jiri Kosina <trivial@kernel.org>

That would involve adding the word "trivial" somewhere in the Subject line,
like (e.g.)
[PATCH 1/9 trivial] README: fix spelling and punctuation in main README file
or
[PATCH 1/9] trivial: fix spelling and punctuation in main README file


I can ack patches 1-3 and 5-8:
Acked-by: Randy Dunlap <rdunlap@infradead.org>


Thanks.

> 
>  COPYING                                   | 10 +++++-----
>  CREDITS                                   |  4 ++--
>  Documentation/00-INDEX                    |  4 ++--
>  Documentation/BUG-HUNTING                 | 10 +++++-----
>  Documentation/CodingStyle                 |  8 ++++----
>  Documentation/HOWTO                       | 22 +++++++++++-----------
>  Documentation/ManagementStyle             | 16 ++++++++--------
>  Documentation/SecurityBugs                |  2 +-
>  Documentation/SubmittingPatches           |  4 ++--
>  Documentation/kbuild/kconfig-language.txt | 18 +++++++++---------
>  MAINTAINERS                               |  2 +-
>  README                                    |  4 ++--
>  REPORTING-BUGS                            |  4 ++--
>  13 files changed, 54 insertions(+), 54 deletions(-)
> 


-- 
~Randy
