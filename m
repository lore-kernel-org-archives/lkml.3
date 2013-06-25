Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3FYQOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:14:34 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:46604 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3FYQOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:14:33 -0400
Date: Tue, 25 Jun 2013 18:14:28 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 03/14] perf: Add persistent event facilities
Message-ID: <20130625161428.GG21579@rric.localhost>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-4-git-send-email-rric@kernel.org>
 <20130624094830.GP28407@twins.programming.kicks-ass.net>
 <20130624192616.GB24827@pd.tnic>
 <20130625074401.GY28407@twins.programming.kicks-ass.net>
 <20130625092439.GD21579@rric.localhost>
 <20130625093706.GA18612@pd.tnic>
 <20130625105135.GF21579@rric.localhost>
 <20130625152941.GD4855@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625152941.GD4855@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.06.13 17:29:41, Borislav Petkov wrote:
> How about
> 
> perf_add_pevent?
> 
> It is nice and short, although maybe too short but "pevent" is almost
> like a special term and the name shows that it is a special type of
> event, i.e. a p-event.

Fine with me, though it's more for internal usage. There is also use
of it as name for event pointers. And, it is used in perf tools as
event parser structure. But otherwise its ok.

-Robert
