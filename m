Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab3GLBlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 21:41:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31723 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab3GLBlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 21:41:04 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=TyVgHLz5XD0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=oLtpoGhtZv4A:10 a=mQxHr3jbpgqjrkQqVigA:9 a=QEXdDO2ut3YA:10 a=lOb67tiyE4sA:10 a=RSiLc5DbJOwA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373593261.17876.61.camel@gandalf.local.home>
Subject: Re: [PATCH] kernel: trace: remove __init from
 race_selftest_startup_function() and trace_selftest_startup_function_graph()
From: Steven Rostedt <rostedt@goodmis.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 11 Jul 2013 21:41:01 -0400
In-Reply-To: <51DF44FA.9060000@asianux.com>
References: <51DDFCF8.2090808@asianux.com>
	 <1373561279.17876.45.camel@gandalf.local.home>
	 <51DF44FA.9060000@asianux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 07:51 +0800, Chen Gang wrote:

> Hmm, can all trace_selftest_startup_* (*selftest* in trace_selftest.c)
> use '__init', so not waste memory keeping them around ?

Yeah, they should all be set to __init, but that's pretty low on the
totem poll, as distros don't enable selftests in their main kernels.

-- Steve


