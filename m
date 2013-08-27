Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3H0NFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:05:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21087 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab3H0NFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:05:11 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=nRXi7Rq_KXAA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=cxZRFzV95EEA:10 a=3nbZYyFuAAAA:8 a=IlEWjyA0xoYVjjpp7jIA:9 a=CjuIK1q_8ugA:10 a=EvKJbDF4Ut8A:10 a=Wurpkc-s4pQA:10 a=IlaMKKf8EWoA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 27 Aug 2013 09:05:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 08/11] trace-cmd: Apply the trace-msg protocol for
 communication between a server and clients
Message-ID: <20130827090509.598591e8@gandalf.local.home>
In-Reply-To: <521C7E1C.5060502@hitachi.com>
References: <20130819094620.26597.79499.stgit@yunodevel>
	<20130819094639.26597.44449.stgit@yunodevel>
	<20130820135658.5a5d6e28@gandalf.local.home>
	<521AB469.40201@hitachi.com>
	<20130826111105.5d6504e0@gandalf.local.home>
	<521C7E1C.5060502@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013 19:23:24 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
 
> OK, let me check that. Even if the old server will receive "V2", the
> server will send port numbers instead of "V2" due to the old protocol.
> In that time, the new client will disconnect from the old server and
> the restarts with the old protocol. Is it OK?

Yep, that's exactly what I meant ;-)

-- Steve
