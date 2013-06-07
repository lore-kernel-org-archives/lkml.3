Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab3FGFrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:47:48 -0400
Received: from 1wt.eu ([62.212.114.60]:36119 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab3FGFrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:47:47 -0400
Date: Fri, 7 Jun 2013 07:47:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [ 132/184] ext4: avoid hang when mounting non-journal
Message-ID: <20130607054741.GL14633@1wt.eu>
References: <20130604172135.779070691@1wt.eu> <1370583872.4021.87.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370583872.4021.87.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 06:44:32AM +0100, Ben Hutchings wrote:
> On Tue, 2013-06-04 at 19:23 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> >  filesystems with orphan list
> > 
> > From: Theodore Ts'o <tytso@mit.edu>
> 
> commit 0e9a9a1ad619e7e987815d20262d36a2f95717ca upstream.

added, thanks Ben.

Willy

