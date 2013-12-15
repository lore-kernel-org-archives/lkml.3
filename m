Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab3LOWGC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 17:06:02 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38467 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab3LOWGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 17:06:00 -0500
X-Originating-IP: 50.43.14.201
Date: Sun, 15 Dec 2013 14:05:52 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH 1/3] SubmittingPatches: Add style recommendation to use
 imperative descriptions
Message-ID: <20131215220551.GA13370@leaf>
References: <20131215205925.GA11106@leaf>
 <20131215211429.GA32667@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131215211429.GA32667@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 10:14:29PM +0100, Borislav Petkov wrote:
> On Sun, Dec 15, 2013 at 12:59:26PM -0800, Josh Triplett wrote:
> > Most commit messages use this style, and the recommendation frequently
> > comes up in discussions (especially in response to patches that don't
> > use it), but that recommendation doesn't actually appear anywhere in
> > Documentation.  Add this style guideline to SubmittingPatches, using the
> > description from git's SubmittingPatches.
> > 
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> 
> Acked-by: Borislav Petkov <bp@suse.de>
> 
> We should probably also document the wished-for structure of a commit
> message:
> 
> The current situation is A. The shortcoming is B. Change/fix it by doing
> C.
> 
> This helps very much in explaining to the unenlightened onlooker what
> a patch is trying to fix without having to ask the author a bunch of
> questions first.

git's SubmittingPatches has some bits that could help there.  I wouldn't
recommend writing the structure quite so rigidly (A and B aren't always
needed, depending on the nature of the problem and the fix), but some
guidance would help.

- Josh Triplett
