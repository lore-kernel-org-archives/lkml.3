Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3KKRfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:35:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab3KKRer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:34:47 -0500
Date: Mon, 11 Nov 2013 18:02:05 +0100
From: Michal Marek <mmarek@suse.cz>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Joe Mario <jmario@redhat.com>
Subject: Re: [PATCH 2/2] kallsyms: Revert back to 128 max symbol length
Message-ID: <20131111170205.GB18517@pobox.suse.cz>
References: <1384177236-8371-1-git-send-email-mmarek@suse.cz> <1384177236-8371-2-git-send-email-mmarek@suse.cz> <20131111141715.GM1962@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111141715.GM1962@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 06:17:15AM -0800, Andi Kleen wrote:
> On Mon, Nov 11, 2013 at 02:40:36PM +0100, Michal Marek wrote:
> > This reverts commits
> > f3462aa (Kbuild: Handle longer symbols in kallsyms.c) and
> > eea0e9c (kbuild: Increase kallsyms max symbol length)
> > except for the added overflow check. The reason is a regression caused
> > by increasing the buffer:
> > http://marc.info/?l=linux-kernel&m=138387700415675.
> 
> Can you please wait a bit until we tracked down the problem?

I'd like to send a pull request to Linus this week.

Michal
