Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab3BYK2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:28:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757188Ab3BYK2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:28:43 -0500
Message-ID: <512B3CD8.5070802@suse.cz>
Date: Mon, 25 Feb 2013 11:28:40 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: linux-next: build failure after merge of the kbuild tree
References: <20130225105650.6b89477b11c895ba99a666fe@canb.auug.org.au>
In-Reply-To: <20130225105650.6b89477b11c895ba99a666fe@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.2.2013 00:56, Stephen Rothwell wrote:
> Hi Michal,
> 
> After merging the kbuild tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> scripts/link-vmlinux.sh: line 135: .: .config: file not found
> 
> Presumably caused by commit 03b25b47e0f4 ("scripts/link-vmlinux.sh:
> source variables from KCONFIG_CONFIG").

Strange, I did a couple of testbuilds before pushing the new branch.
Wild guess: what version of what shell are you using on the
buildmachine? It is probably the missing ./ that makes the difference.

Thanks,
Michal
