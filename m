Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbbAHPJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:09:08 -0500
Received: from mail.kernel.org ([198.145.29.136]:47235 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbbAHPJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:09:05 -0500
Date: Thu, 8 Jan 2015 12:09:01 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: "perf top -g" leaking ~300MB per second.
Message-ID: <20150108150901.GE15396@kernel.org>
References: <20141213084845.GA13453@x4>
 <20141213090331.GB13453@x4>
 <20141213152635.GG9845@kernel.org>
 <548C828B.4040309@gmail.com>
 <20141230053813.GD6081@sejong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141230053813.GD6081@sejong>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 30, 2014 at 02:38:13PM +0900, Namhyung Kim escreveu:
> Subject: [PATCH] perf callchain: Free callchains when hist entries are deleted
 
> Markus reported that "perf top -g" can leak ~300MB per second on his
> machine.  This is partly because it missed to free callchains when
> hist entries are deleted.  Fix it.

Thanks, applied.

- Arnaldo
