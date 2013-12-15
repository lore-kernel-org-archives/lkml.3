Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab3LOVOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 16:14:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47042 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab3LOVOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 16:14:32 -0500
Date: Sun, 15 Dec 2013 22:14:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH 1/3] SubmittingPatches: Add style recommendation to use
 imperative descriptions
Message-ID: <20131215211429.GA32667@pd.tnic>
References: <20131215205925.GA11106@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131215205925.GA11106@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 12:59:26PM -0800, Josh Triplett wrote:
> Most commit messages use this style, and the recommendation frequently
> comes up in discussions (especially in response to patches that don't
> use it), but that recommendation doesn't actually appear anywhere in
> Documentation.  Add this style guideline to SubmittingPatches, using the
> description from git's SubmittingPatches.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Borislav Petkov <bp@suse.de>

We should probably also document the wished-for structure of a commit
message:

The current situation is A. The shortcoming is B. Change/fix it by doing
C.

This helps very much in explaining to the unenlightened onlooker what
a patch is trying to fix without having to ask the author a bunch of
questions first.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
