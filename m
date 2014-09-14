Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaINNXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 09:23:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbaINNXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 09:23:43 -0400
Date: Sun, 14 Sep 2014 15:23:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Avi Kivity <avi@cloudius-systems.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH] perf: disable kernel symbol demangling by default
Message-ID: <20140914132336.GC1731@krava.redhat.com>
References: <1410581705-26968-1-git-send-email-avi@cloudius-systems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410581705-26968-1-git-send-email-avi@cloudius-systems.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 07:15:05AM +0300, Avi Kivity wrote:
> Some Linux symbols (for example __vt_event_wait) are interpreted by
> the demangler as C++ mangled names, which of course they aren't.
> 
> Disable kernel symbol demangling by default to avoid this, and
> allow enabling it with a new option --demangle-kernel for those who
> wish it.
> 
> Reported-by: Jiri Olsa <jolsa@redhat.com>

looks good to me
Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
