Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbaDHIGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:06:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbaDHIGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:06:11 -0400
Message-ID: <5343ADF1.1060906@suse.cz>
Date: Tue, 08 Apr 2014 10:06:09 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: strange state of the kbuild tree
References: <20140408074734.34deb43270183941b5118c7f@canb.auug.org.au>
In-Reply-To: <20140408074734.34deb43270183941b5118c7f@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-07 23:47, Stephen Rothwell wrote:
> Hi Michal,
> 
> I noticed that you have two copies of two commits in your tree ("Kbuild,
> lto: Set TMPDIR for LTO v4" and "Kbuild, lto: Add Link Time Optimization
> support v3").  I understan why you recommitted them (to add your
> Signed-off-by), but to leave the unsigned commits in there sort of
> defeats the purpose.  This is probably a case where you should have
> removed the original merge (or just these two commits) and then merged
> the new version.

Sorry about that.


> I am not sure what you intend to send to Linus, but this whole tree (in
> one piece) should not be it.  From the state of the tree, it looks like
> you send your separate topic branches (or a new merge of them) which
> should be ok, but please after doing that, clean up your for-next branch
> (it current has merge commits dating back to May, 2103 in it).

Right, I send the individual topic branches to Linus. Will it be OK if I
reset the for-next branch to v3.15-rc1 after this merge window?

Thanks,
Michal

