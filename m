Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab3AMDuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 22:50:40 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:40991 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab3AMDuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 22:50:39 -0500
MIME-Version: 1.0
In-Reply-To: <422821122.79411357913979039.JavaMail.root@srv11.zimbra.polymtl.ca>
References: <917750116.79371357913957820.JavaMail.root@srv11.zimbra.polymtl.ca>
	<422821122.79411357913979039.JavaMail.root@srv11.zimbra.polymtl.ca>
Date: Sun, 13 Jan 2013 11:50:38 +0800
Message-ID: <CACV3sb+=VEBnpZm1oVRCSFrhxZSpnss_U_7BEP35kLHEd7J5JA@mail.gmail.com>
Subject: Re: [RFC] ktap: Another dynamic tracing tool for Linux
From: Jovi Zhang <bookjovi@gmail.com>
To: Michel Dagenais <michel.dagenais@polymtl.ca>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 10:19 PM, Michel Dagenais
<michel.dagenais@polymtl.ca> wrote:
> You may be interested in KGTP which implements a simple bytecode interpreter
> in the kernel to accept GDB tracepoints http://code.google.com/p/kgtp/
>
> The bytecode is quite limited but would be easy to extend.
KGTP is still not meet my requirement on Linux tracing.
ktap don't have gcc or gdb dependence, it's build from scratch, with a
clean design, this is very important.

You will find more differences if you watch ktap and kgtp deeply. :)

>
> Eventually we should be able to connect LTTng http://lttng.org/ and KGTP in
> order to benefit from the efficiency of LTTng for activating probes and
> retrieving data.
You are right, LTTng should be possible, and I already planed it, also
on some functionality of ftrace and systemtap.

Let's wait public ktap for a little time, you then can get a basic
overview on ktap.
