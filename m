Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3KGAua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:50:30 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:54376 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3KGAu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:50:28 -0500
Date: Thu, 7 Nov 2013 01:50:27 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH net-next v4 3/9] static_key: WARN on usage before jump_label_init was called
Message-ID: <20131107005027.GC8144@order.stressinduktion.org>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
	Jason Baron <jbaron@akamai.com>
References: <1382212139-20301-1-git-send-email-hannes@stressinduktion.org> <1382212139-20301-4-git-send-email-hannes@stressinduktion.org> <20131106161649.2bb1dbb0@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131106161649.2bb1dbb0@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 04:16:49PM -0500, Steven Rostedt wrote:
> Sorry for the late reply, but this was sent while I was getting ready
> for my two week conference trip.
> 
> Note, this should not go through the net tree, but instead should go
> through tip, as it deals with jump labels and not networking.
> 
> Otherwise, this patch looks good.
> 
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

Thanks for the review!

The patch already got queued up in net-next. Is this ok or what do you
suggest to resolve this?

Greetings,

  Hannes

