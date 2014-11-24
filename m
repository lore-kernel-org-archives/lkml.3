Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaKXRjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:39:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbaKXRjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:39:10 -0500
Date: Mon, 24 Nov 2014 18:39:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>, torvalds@linux-foundation.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs deadlock fix
Message-ID: <20141124173909.GC26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Chris Mason <clm@fb.com>,
	torvalds@linux-foundation.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20141123151439.GA16816@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141123151439.GA16816@ret.masoncoding.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

I thought the fix for the scrub/replace deadlock would be included in
this pull, I can reproduce it on each run of xfstests with 3.18-rc.

btrfs: fix dead lock while running replace and defrag concurrently
https://patchwork.kernel.org/patch/5264531/

I've retested it again including this pull and still deadlocks reliably
at btrfs/070.
