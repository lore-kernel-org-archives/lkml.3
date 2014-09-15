Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaIOShY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:37:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:44380 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaIOShX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:37:23 -0400
Date: Mon, 15 Sep 2014 15:37:18 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Avi Kivity <avi@cloudius-systems.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: disable kernel symbol demangling by default
Message-ID: <20140915183718.GF11199@kernel.org>
References: <1410581705-26968-1-git-send-email-avi@cloudius-systems.com>
 <20140914132336.GC1731@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140914132336.GC1731@krava.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Sep 14, 2014 at 03:23:36PM +0200, Jiri Olsa escreveu:
> On Sat, Sep 13, 2014 at 07:15:05AM +0300, Avi Kivity wrote:
> > Some Linux symbols (for example __vt_event_wait) are interpreted by
> > the demangler as C++ mangled names, which of course they aren't.
> > 
> > Disable kernel symbol demangling by default to avoid this, and
> > allow enabling it with a new option --demangle-kernel for those who
> > wish it.
> > 
> > Reported-by: Jiri Olsa <jolsa@redhat.com>
> 
> looks good to me
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied.

- Arnaldo
