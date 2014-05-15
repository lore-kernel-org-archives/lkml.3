Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaEOF12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 01:27:28 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:51687 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaEOF10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 01:27:26 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 15 May 2014 01:31:16 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Vince Weaver <vincent.weaver@maine.edu>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
In-Reply-To: <20140514203924.GE28328@moon>
Message-ID: <alpine.DEB.2.10.1405150127550.30231@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu> <20140506202307.GA1458@moon> <20140508020050.GX39568@redhat.com> <20140508073756.GM8607@moon> <20140508074930.GN8607@moon> <20140508080234.GO8607@moon>
 <alpine.DEB.2.10.1405091211430.13652@vincent-weaver-1.umelst.maine.edu> <20140514203924.GE28328@moon>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Cyrill Gorcunov wrote:

> So I'm experiencing the same problem on latest -tip + my patches applied.

glad it's not just me.

I find the problem to be reproducible and so in theory it might be 
possible to generate a small reproducing test case.  
I meant to do that already but I got distracted 
by other things.

I think I managed to have a trace I recorded and replayed recreate the 
issue, but narrowing things down from a 2000+ syscall trace can be 
tedious.

Let me know if you have any other issues with the perf_fuzzer.

Vince
