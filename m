Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935368Ab3DHL4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:56:49 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:61488 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935108Ab3DHL4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:56:47 -0400
Date: Mon, 8 Apr 2013 13:56:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf sched: Move struct perf_sched definition out of
 cmd_sched()
Message-ID: <20130408115643.GB7513@gmail.com>
References: <1365157320-22586-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365157320-22586-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> For some reason it consumed quite amount of compile time when declared
> as local variable, and it disappeared when moved out of the function.
> Moving other variables/tables didn't help.
> 
> On my system this single-file-change build time reduced from 11s to 3s.

Amazing effect!

Thanks,

	Ingo
