Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3HPMs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:48:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab3HPMsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:48:54 -0400
Message-ID: <520E1FAF.3020003@suse.cz>
Date: Fri, 16 Aug 2013 14:48:47 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [pull request] Pull request for branch yem/kconfig-for-next
References: <cover.1376600922.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1376600922.git.yann.morin.1998@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.8.2013 23:17, Yann E. MORIN wrote:
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> Hello Michal,
> 
> Please pull a few more changes queued for 3.12 since your last pull:
> 
>   - POSIX compliance when using sed in scripts/config    (CLément)
>   - use 'long long' to represent hex and ranges, so their width
>     is not dependent on the architecture (32/64 bits)    (Kees)
>   - remove the warning when parsing auto.conf, that frigthened
>     Linus when he merged the ext4 tree
>   - explicit use CONFIG_MODULES to enable tristates

Pulled, thanks! Now you can remove the CONFIG_MODULES special handling
from kconfig.

Michal
