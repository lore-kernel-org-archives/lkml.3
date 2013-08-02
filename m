Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3HBNu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 09:50:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab3HBNu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 09:50:57 -0400
Date: Fri, 2 Aug 2013 15:45:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [for-next-3.11][PATCH 0/5] tracing: Final fixes for the race
	between open event file and deleting event
Message-ID: <20130802134530.GA18839@redhat.com>
References: <20130802024924.999067099@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802024924.999067099@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Steven Rostedt wrote:
>
> Is all the races that we are aware of between accessing event files and
> deleting events covered by these patches?  I think I have them all.

Yes, I believe this covers all problems we discussed. I am not aware
of any other problem in this area.

Oleg.

