Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab3EaRFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:05:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9941 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3EaRFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:05:37 -0400
X-Authority-Analysis: v=2.0 cv=H9pZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=vmvkG-yRlGgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=PQwVvu5Sp8AA:10 a=D19gQVrFAAAA:8 a=AcqKezMENUfuMrbtBEkA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370019935.26799.53.camel@gandalf.local.home>
Subject: Re: old version of trace-cmd broken on 3.10 kernel
From: Steven Rostedt <rostedt@goodmis.org>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 31 May 2013 13:05:35 -0400
In-Reply-To: <20130531165026.GC2910@sbohrermbp13-local.rgmadvisors.com>
References: <20130531165026.GC2910@sbohrermbp13-local.rgmadvisors.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-31 at 11:50 -0500, Shawn Bohrer wrote:
> Not sure if this is a big deal or not.  I've got an old version of
> trace-cmd. It was built from git on 2012-09-12 but sadly I didn't
> stash away the exact commit hash.  Anyway this version works fine on a
> 3.4 kernel but on a 3.10-rc3 kernel it no longer works.  I just pulled
> the latest trace-cmd from git and it works fine on the 3.10 kernel so
> maybe this isn't an issue, but I don't typically expect applications
> to break with a kernel upgrade.
> 
> When I run the old version on 3.10.0-rc3 I get the following output:

Yep, in 3.10 I fixed a long standing bug in the splice code, that when
fixed, the old trace-cmd would fail.

I made a fix to all the stable releases of trace-cmd and posted it to
LKML back on March 1st.

https://lkml.org/lkml/2013/3/1/596

-- Steve


