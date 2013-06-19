Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935107Ab3FSUkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:40:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934714Ab3FSUkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:40:33 -0400
Message-ID: <51C2173E.3080405@suse.cz>
Date: Wed, 19 Jun 2013 22:40:30 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [pull request] Pull request for branch yem-kconfig-for-next
References: <cover.1371595499.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 19.6.2013 00:44, Yann E. MORIN napsal(a):
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> Hello Michal, All!
> 
> These are the patches against kconfig that I have accumulated for 3.11,
> and for which I plan to later send a proper pull-request.
> 
> Note-whorthy this time:
>   - fix values of tristates that are selected by boolean choices (Arve)
>   - fix choice randomisation in presence of KCONFIG_ALLCONFIG    (me)
>   - fix choice randomisation selecting more than one value in
>     a choice (but only if it is conditional)                     (me)
>   - fix choice-in-a-choice randomisation not selecting any value
>     for the inner-most choice                                    (me)
> 
> Also, some code-cleanups and eye-candy:
>   - mconf and nconf code cleanups                                (Dirk, Sedat)
>   - mconf and nconf eye-candy                                    (Dirk)
>   - scripts/config script-name in help text                      (Clément)
>   - heuristic to sort found symbols by relevance                 (me)
>   - more randconfig debugging help                               (me)
> 
> Note: this series is for review before I send an official pull-request.
> I want to avoid the debacle [0] [1] of the last kconfig breakage I caused
> with my previous kconfig "fix" to randomising choices in presence of
> KCONFIG_ALLCONFIG.
> 
> I would like to send an official pull-request early next week, so all of
> these can land early in -next, so they get some real-life t4esting before
> the next merge windows open. So please, please, test this carefully. ;-)

I tested this a bit, it works fine. Unless somebody else finds issues,
I'll merge it.

Thanks,
Michal

