Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaGBOWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:22:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:30826 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751708AbaGBOWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:22:13 -0400
Date: Wed, 2 Jul 2014 10:22:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: [RFA][PATCH 23/27] metag: ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140702102211.7a8956a2@gandalf.local.home>
In-Reply-To: <53B40A4F.7060102@imgtec.com>
References: <20140626165221.736847419@goodmis.org>
	<20140626165853.049120840@goodmis.org>
	<20140626133848.0567e365@gandalf.local.home>
	<53B40A4F.7060102@imgtec.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014 14:34:07 +0100
James Hogan <james.hogan@imgtec.com> wrote:

> This patch is pretty much the inverse of the original patch that added
> it, so looks good to me (and it didn't seem to break anything).
> 
> So, for both this patch and the "ftrace: Remove check for
> HAVE_FUNCTION_TRACE_MCOUNT_TEST" one:
> 
> Acked-by: James Hogan <james.hogan@imgtec.com>

Thanks!

-- Steve

