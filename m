Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbaAFTyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:54:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:63744 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755376AbaAFTyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:54:54 -0500
Date: Mon, 6 Jan 2014 14:54:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH trace-cmd 0/1] Makefile: Use CPPFLAGS from the
 environment
Message-ID: <20140106145450.77f7bf86@gandalf.local.home>
In-Reply-To: <20140106193652.GB1556@thinkpad-t410>
References: <1389030985-26657-1-git-send-email-seth.forshee@canonical.com>
	<20140106140753.55f3f3c7@gandalf.local.home>
	<20140106193652.GB1556@thinkpad-t410>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jan 2014 13:36:52 -0600
Seth Forshee <seth.forshee@canonical.com> wrote:

> There is something odd about the updates you pushed though. You've now
> got a version 2.2.1 on your trace-cmd-stable-v2.2 branch, which used to
> be tagged trace-cmd-v2.2.1, and another 2.2.1 on master which now has
> that tag. I'm guessing that's not what you intended to do?

Yeah, I screwed up.

This should have been 2.3 and I screwed up the tags here :-/

I'll try to fix things up.

-- Steve
