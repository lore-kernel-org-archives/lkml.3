Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbaEIBYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 21:24:02 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:64993 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754438AbaEIBYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 21:24:00 -0400
Date: Thu, 8 May 2014 21:23:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] tracing: Use inline task_nice() to get rid of an
 open coded implementation of it.
Message-ID: <20140508212356.1e9ddeb8@gandalf.local.home>
In-Reply-To: <536C1E97.3080701@cn.fujitsu.com>
References: <20140318221533.45c479bd@gandalf.local.home>
	<1399531103-920-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<536C1E97.3080701@cn.fujitsu.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014 09:17:27 +0900
Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:

> Hi steven, as you request, I resend this patch now when function task_nice()
> is already in mainline. Do you want to take it?
> 

Yeah, I probably will. I've just been a bit busy with other things at
the moment.

-- Steve
