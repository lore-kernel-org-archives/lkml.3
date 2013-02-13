Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846Ab3BMLOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 06:14:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab3BMLOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 06:14:45 -0500
Date: Wed, 13 Feb 2013 11:14:40 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, riel@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org
Subject: Re: [PATCH] x86: mm: Check if PUD is large when validating a kernel
 address v2
Message-ID: <20130213111440.GJ4100@suse.de>
References: <20130211145236.GX21389@suse.de>
 <20130213110202.GI4100@suse.de>
 <20130213111031.GA11320@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130213111031.GA11320@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 12:10:31PM +0100, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > Andrew or Ingo, please pick up.
> 
> Already did - will push it out later today.
> 

Whoops, thanks. Sorry for the noise.

-- 
Mel Gorman
SUSE Labs
