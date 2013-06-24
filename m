Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab3FXVnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 17:43:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab3FXVnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 17:43:03 -0400
Message-ID: <51C8BD63.8030205@suse.cz>
Date: Mon, 24 Jun 2013 23:42:59 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [pull request v2] Pull request for branch yem-kconfig-for-next
References: <cover.1372097219.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1372097219.git.yann.morin.1998@free.fr>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 24.6.2013 20:11, Yann E. MORIN napsal(a):
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> Hello Michal, All!
>                                                                                                                                                                                       │
> Michal, please pull these patches against kconfig that I have accumulated
> for 3.11.
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
>   - mconf and nconf eye-candy                                    (Dirk, me)
>   - scripts/config script-name in help text                      (Clément)
>   - heuristic to sort found symbols by relevance                 (me)
>   - more randconfig debugging help                               (me)
> 
> Changes v1 -> v2:
>   - simplify sorting heuristic (Jean)
>   - make it clear in mconf/nconf that the search expression can
>     be a regexp (Jean)

Pulled, thanks a lot!

Michal
