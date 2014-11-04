Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaKDUAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:00:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52476 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaKDUAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:00:07 -0500
Date: Tue, 4 Nov 2014 20:59:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Chen Gong <gong.chen@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC][PATCH 02/12 v3] RAS/tracing: Use trace_seq_buffer_ptr()
 helper instead of open coded
Message-ID: <20141104195958.GG7793@pd.tnic>
References: <20141104155237.228431433@goodmis.org>
 <20141104160221.717247815@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141104160221.717247815@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 10:52:39AM -0500, Steven Rostedt wrote:
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

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
