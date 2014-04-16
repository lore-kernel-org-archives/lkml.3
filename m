Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbaDPMIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:08:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900AbaDPMIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:08:04 -0400
Message-ID: <1397650080.2725.3.camel@localhost>
Subject: Re: linux-next: manual merge of the audit tree with Linus' tree
From: Eric Paris <eparis@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Date: Wed, 16 Apr 2014 08:08:00 -0400
In-Reply-To: <20140416140240.dd99f42196991edcb73a969d@canb.auug.org.au>
References: <20140416140240.dd99f42196991edcb73a969d@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 14:02 +1000, Stephen Rothwell wrote:

> You could have avoided this by doing a fast forward merge of v3.15-rc1
> instead of the v3.14 merge (since everything in your tree before that
> merge was also in Linus' tree by v3.15-rc1).

This is a situation I've never really known the right way to handle.  I
certainly could/can fast forward to 3.15-rc1, but then I have a random
crap development base for the audit tree.  Which is especially bad sine
-rc1 doesn't even boot on my main machine.

What I've always done is to merge the last release right after the pull
and go from there, but it clearly leaves conflict potential

Which is preferred?  I've always enjoyed having my trees based on a
release....

