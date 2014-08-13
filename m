Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaHMS4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:56:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:47394 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaHMS4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:56:17 -0400
Date: Wed, 13 Aug 2014 15:56:13 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Naohiro Aota <naota@elisp.net>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] [BUGFIX] perf probe: Fix --list option to show
 events only with uprobe events
Message-ID: <20140813185613.GD2718@kernel.org>
References: <20140813161248.26440.84370.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813161248.26440.84370.stgit@kbuild-fedora.novalocal>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 13, 2014 at 04:12:48PM +0000, Masami Hiramatsu escreveu:
> Current perf probe --list doesn't work if only CONFIG_UPROBE_EVENTS=y
> because it aborts when it fails to open kprobe_events file before
> checking uprobe_events file.

Thanks, applied both patches.

- Arnaldo
