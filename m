Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaKEK34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:29:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaKEK3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:29:53 -0500
Date: Wed, 5 Nov 2014 11:29:39 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chen Gong <gong.chen@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC][PATCH 02/12 v3] RAS/tracing: Use trace_seq_buffer_ptr()
 helper instead of open coded
Message-ID: <20141105102939.GB4570@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160221.717247815@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104160221.717247815@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-04 10:52:39, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Use the helper function trace_seq_buffer_ptr() to get the current location
> of the next buffer write of a trace_seq object, instead of open coding
> it.
> 
> This facilitates the conversion of trace_seq to use seq_buf.
> 
> Cc: Chen Gong <gong.chen@linux.intel.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
