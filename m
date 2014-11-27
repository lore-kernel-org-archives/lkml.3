Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaK0QUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:20:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:57885 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaK0QUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:20:48 -0500
Message-ID: <54774F58.1000709@linutronix.de>
Date: Thu, 27 Nov 2014 17:20:40 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>,
        Alexandre Montplaisir <alexmonthy@voxpopuli.im>
CC: linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Trace Compass Developer Discussions 
	<tracecompass-dev@eclipse.org>
Subject: Re: Support for Perf CTF traces now in master (was Re: FW: [RFC 0/5]
 perf tools: Add perf data CTF conversion)
References: <53F38C74.4030300@voxpopuli.im> <20140820092858.GA1203@krava.brq.redhat.com> <53F4F38C.4080407@voxpopuli.im> <5457C259.8030605@linutronix.de> <545829CA.7040900@voxpopuli.im> <20141105125028.GA30087@linutronix.de> <545AEA37.601@voxpopuli.im> <5460156E.3050601@voxpopuli.im> <5463DBD5.9080303@voxpopuli.im> <20141127154302.GA4924@krava.brq.redhat.com>
In-Reply-To: <20141127154302.GA4924@krava.brq.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2014 04:43 PM, Jiri Olsa wrote:

> hi,
> any other way besides compiling eclipse to test this? For pure mortals
> with Fedora eclipse rpm.. ;-)
> 
> or any instructions for the compilation.. I actually haven't checked yet

| mvn clean install -Pbuild-rcp -Dmaven.test.skip=true

does the trick. It took a while to complete especially since it sucked
some jars at 30KiB/sec

That archive at
	https://breakpoint.cc/perf-ctf/trace-compass-0.1.0-20141126-1744-linux.gtk.x86_64.tar.xz

contains the standalone application "tracecompass" without eclipse. It
contains also the patch I quoted in the thread.

> thanks,
> jirka

Sebastian
