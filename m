Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968074Ab3HIQ04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:26:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967935Ab3HIQ0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:26:55 -0400
Date: Fri, 9 Aug 2013 18:21:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a
	ring buffer
Message-ID: <20130809162115.GB7144@redhat.com>
References: <1376037909-17797-1-git-send-email-namhyung@kernel.org> <1376037909-17797-11-git-send-email-namhyung@kernel.org> <5204BCE6.2070102@hitachi.com> <20130809162002.GA7144@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809162002.GA7144@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09, Oleg Nesterov wrote:
>
> Steven, Jovi, what should we do with that patch? It seems that it
> was forgotten.
>
> I can take these patches into my ubprobes branch

I meant that patch from Jovi, sorry for confusion.

Oleg.

