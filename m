Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaF0GBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 02:01:09 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:56786 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaF0GBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 02:01:07 -0400
Date: Fri, 27 Jun 2014 08:01:02 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFA][PATCH 26/27] s390/ftrace: remove check of obsolete
 variable function_trace_stop
Message-ID: <20140627060102.GA4396@osiris>
References: <20140626165221.736847419@goodmis.org>
 <20140626165853.685458770@goodmis.org>
 <20140626134141.18d92f1d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626134141.18d92f1d@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062706-0342-0000-0000-00000040291A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 01:41:41PM -0400, Steven Rostedt wrote:
> 
> I know you wrote this patch, but you may want to test it out with
> the ftrace: Remove check for HAVE_FUNCTION_TRACE_MCOUNT_TEST patch
> applied too.

In order to compile this, I'd have to apply all common code patches, I think.
But they don't apply against Linus' master tree and I wouldn't know which
tree these patches are against.
But anyway, it all looks good ;)

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

