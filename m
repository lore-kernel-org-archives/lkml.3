Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab3JRAvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 20:51:33 -0400
Received: from one.firstfloor.org ([193.170.194.197]:55016 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3JRAvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 20:51:00 -0400
Date: Fri, 18 Oct 2013 02:50:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH net-next v3 3/9] static_key: WARN on usage before
 jump_label_init was called
Message-ID: <20131018005057.GL2592@two.firstfloor.org>
References: <1381987923-1524-1-git-send-email-hannes@stressinduktion.org>
 <1381987923-1524-4-git-send-email-hannes@stressinduktion.org>
 <20131017171940.173bab09@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017171940.173bab09@gandalf.local.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 05:19:40PM -0400, Steven Rostedt wrote:
> On Thu, 17 Oct 2013 07:31:57 +0200
> Hannes Frederic Sowa <hannes@stressinduktion.org> wrote:
> 
> > Based on a patch from Andi Kleen.
> 
> I'm fine with the patch, but the change log needs a lot more work.
> Like, why is this needed?  I know, but does anyone else?

Or just merge the orininal patch. While being less verbose
in the warning it had a full changelog.

-Andi
