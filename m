Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3EMPIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:08:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9880 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3EMPIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:08:20 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=IfZmsvL57AAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=bHkaHOLzWfIA:10 a=oGMlB6cnAAAA:8 a=D19gQVrFAAAA:8 a=2ddL0d-UFJEsrsrpJ5QA:9 a=QEXdDO2ut3YA:10 a=CY6gl2JlH4YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368457698.6828.34.camel@gandalf.local.home>
Subject: Re: [page fault tracepoint 1/2] Add page fault trace event
 definitions
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Francis Deslauriers <fdeslaur@gmail.com>, linux-mm@kvack.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        fweisbec@gmail.com, raphael.beamonte@gmail.com,
        linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Mon, 13 May 2013 11:08:18 -0400
In-Reply-To: <20130513112132.GA15168@Krystal>
References: <1368079520-11015-1-git-send-email-fdeslaur@gmail.com>
	 <518B464E.6010208@huawei.com> <518BA91E.3080406@zytor.com>
	 <20130513112132.GA15168@Krystal>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 07:21 -0400, Mathieu Desnoyers wrote:
> * H. Peter Anvin (hpa@zytor.com) wrote:

> Who is leading this IDT instrumentation effort ?
> 

Seiji has been doing most of the work. I've just been busy doing other
things but I need to start getting this tidied up, and hopefully this
can get into 3.11.

https://lkml.org/lkml/2013/4/5/401

-- Steve


