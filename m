Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3KDO6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:58:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab3KDO6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:58:32 -0500
Date: Mon, 4 Nov 2013 14:58:28 +0000
From: Mel Gorman <mgorman@suse.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: mm, numa: test segfaults, only when NUMA balancing is on
Message-ID: <20131104145828.GA1218@suse.de>
References: <20131016155429.GP25735@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131016155429.GP25735@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:54:29AM -0500, Alex Thorlton wrote:
> Hi guys,
> 
> I ran into a bug a week or so ago, that I believe has something to do
> with NUMA balancing, but I'm having a tough time tracking down exactly
> what is causing it.  When running with the following configuration
> options set:
> 

Can you test with patches
cd65718712469ad844467250e8fad20a5838baae..0255d491848032f6c601b6410c3b8ebded3a37b1
applied? They fix some known memory corruption problems, were merged for
3.12 (so alternatively just test 3.12) and have been tagged for -stable.

Thanks.

-- 
Mel Gorman
SUSE Labs
