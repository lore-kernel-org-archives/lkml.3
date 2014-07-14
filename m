Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbaGNQE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:04:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157AbaGNQET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:04:19 -0400
Date: Mon, 14 Jul 2014 18:02:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] tracing: change filter_free_subsystem_*() to check
	->subsystem rather then ->name
Message-ID: <20140714160237.GB11986@redhat.com>
References: <20140711190655.GA19549@redhat.com> <1405346299.1745.21.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405346299.1745.21.camel@leonhard>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14, Namhyung Kim wrote:
>
> 2014-07-11 (금), 21:06 +0200, Oleg Nesterov:
> > filter_free_subsystem_preds() and filter_free_subsystem_filters()
> > can rely on file->system->subsystem and avoid strcmp().
>
> I guess the same can go to the replace_system_preds() too.

Hmm, indeed ;) I'll send "v2 7/7".

Thanks!

Oleg.

