Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaKLM4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:56:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:53322 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaKLM4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:56:32 -0500
Date: Wed, 12 Nov 2014 09:56:26 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: WANG Chao <chaowang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] perf test: fix typo in python test
Message-ID: <20141112125626.GW18464@kernel.org>
References: <1415780826-13250-1-git-send-email-chaowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415780826-13250-1-git-send-email-chaowang@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 12, 2014 at 04:27:05PM +0800, WANG Chao escreveu:
> Library loading in python syntax should be 'import perf', not 'use perf'.

Thanks, applied.

- Arnaldo
