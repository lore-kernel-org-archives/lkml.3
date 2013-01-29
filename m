Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab3A2O6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 09:58:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20698 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab3A2O6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:58:30 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=byQ7d0dDu3kA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=pup-11UIvNYA:10 a=pGLkceISAAAA:8 a=GKwTG3RjFeVf04RS43AA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359471509.17639.33.camel@gandalf.local.home>
Subject: Re: [PATCH] tracing: fix twice trace iterator init
From: Steven Rostedt <rostedt@goodmis.org>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Tue, 29 Jan 2013 09:58:29 -0500
In-Reply-To: <CACV3sb+G1YnO6168JhY3dEadmJi58pA5-2cSZT8E0WVHJNFt9Q@mail.gmail.com>
References: <CACV3sb+G1YnO6168JhY3dEadmJi58pA5-2cSZT8E0WVHJNFt9Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 18:20 +0800, Jovi Zhang wrote:
> >From ac499cd340bf2ba47b3d1dd129a3bb7527c195ae Mon Sep 17 00:00:00 2001
> From: Jovi Zhang <bookjovi@gmail.com>
> Date: Fri, 25 Jan 2013 18:03:07 +0800
> Subject: [PATCH] tracing: fix twice trace iterator init
> 
> trace iterator is already inited in trace_init_global_iter,
> so there don't need to assign again.
> 
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>

Applied, Thanks Jovi!

-- Steve


