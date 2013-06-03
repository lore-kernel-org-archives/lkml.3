Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483Ab3FCSHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:07:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab3FCSHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:07:22 -0400
Date: Mon, 3 Jun 2013 20:06:46 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: [RFC] perf record: Remove -A option
Message-ID: <20130603180646.GE8758@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
the -A option (append data to the output file) for record
command is broken, probably for some time now.

Anyone interested in this functionality? As we discussed
this with Arnaldo he and I would vote for removal.

thoughts?

thanks,
jirka
