Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbaKRQkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:40:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbaKRQkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:40:17 -0500
Date: Tue, 18 Nov 2014 17:40:25 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 20/26 v5] seq_buf: Add seq_buf_can_fit() helper function
Message-ID: <20141118164025.GL23958@pathway.suse.cz>
References: <20141115045847.712848224@goodmis.org>
 <20141115050604.073390701@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115050604.073390701@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-14 23:59:07, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Add a seq_buf_can_fit() helper function that removes the possible mistakes
> of comparing the seq_buf length plus added data compared to the size of
> the buffer.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
