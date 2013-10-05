Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3JERF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:05:56 -0400
Received: from one.firstfloor.org ([193.170.194.197]:49607 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3JERFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:05:55 -0400
Date: Sat, 5 Oct 2013 19:05:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Message-ID: <20131005170552.GI6882@two.firstfloor.org>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-7-git-send-email-andi@firstfloor.org>
 <20131005070806.GA16922@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131005070806.GA16922@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 09:08:06AM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > As suggested by Ingo.
> 
> No, you haven't read my suggestion carefully enough so NAK.

Ok I trust you will do a better solution then to save the 700+k text.
Ball is in your court.

-Andi
