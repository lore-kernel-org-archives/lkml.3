Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbbAVDGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:06:39 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:63928 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752358AbbAVDGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:06:34 -0500
Date: Wed, 21 Jan 2015 22:07:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150121220701.22231849@grimm.local.home>
In-Reply-To: <20150121204725.71933044@grimm.local.home>
References: <20150121171953.823177070@goodmis.org>
	<20150121230007.GA10389@kroah.com>
	<20150121204725.71933044@grimm.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 20:47:25 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> Well, if I switch to using kernfs, I expect we should ignore this
> version as well, as I would think it would make this series obsolete.

Is there any documentation on kernfs? I can't find anything that makes
it any easier than what I already have.

-- Steve
