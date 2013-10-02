Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3JBUvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:51:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab3JBUvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:51:20 -0400
Message-ID: <524C8744.3030402@suse.cz>
Date: Wed, 02 Oct 2013 22:51:16 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, Robert Richter <rric@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [pull request] Pull request for branch yem/kconfig-rc-fixes
References: <cover.1380560241.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1380560241.git.yann.morin.1998@free.fr>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 30.9.2013 19:01, Yann E. MORIN napsal(a):
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> Michal,
> 
> Please pull these two changes for 3.12-rc:
>   - a fix for "make install" on ARM, by Robert Richter, acked by Linus
>     and yourself;

I cherry-picked this commit to kbuild.git#rc-fixes.


>   - a fix for "make allmodconfig" when KCONFIG_ALLCONFIG is set, which
>     already flew on the list, but with a better commit log now.

I reported a problem with this one in the original thread.

Michal

