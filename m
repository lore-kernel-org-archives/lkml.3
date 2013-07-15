Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab3GOTRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:17:18 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57124 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab3GOTRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:17:17 -0400
Date: Mon, 15 Jul 2013 20:17:08 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: rebase of the drivers-x86 tree
Message-ID: <20130715191708.GA514@srcf.ucam.org>
References: <20130711100437.4e5198a27a72dcdd3f69200f@canb.auug.org.au>
 <f7e5023f-0e7e-4da1-a91d-5b9f4fd0db21@email.android.com>
 <20130715101306.6d6fc3cb42ce956130606ac2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715101306.6d6fc3cb42ce956130606ac2@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 10:13:06AM +1000, Stephen Rothwell wrote:

> That is hardly a reason to rebase your tree.  Just add another commit to
> correct the situation.  The tree as it stood would not have affected
> anyone's building, running or bisecting.

I verified that the only difference before and after rebasing was that 
the file permission was back the way it should be. Why clutter history?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
