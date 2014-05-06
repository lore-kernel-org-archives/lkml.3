Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaEFOxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:53:10 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:54956
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547AbaEFOxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:53:08 -0400
Date: Tue, 6 May 2014 09:53:06 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: tracing: Replace __get_cpu_var uses with this_cpu_ptr
In-Reply-To: <20140506083536.7316e35a@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1405060952410.11033@gentwo.org>
References: <alpine.DEB.2.10.1404291415560.18364@gentwo.org> <20140506083536.7316e35a@gandalf.local.home>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014, Steven Rostedt wrote:

> I pulled this into my 3.16 queue.

Thanks.
