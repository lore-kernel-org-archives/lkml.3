Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaGQIFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:05:23 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43982 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbaGQIFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:05:15 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] tracing: ->filter cleanups
References: <20140715184753.GA20470@redhat.com>
Date: Thu, 17 Jul 2014 17:05:11 +0900
In-Reply-To: <20140715184753.GA20470@redhat.com> (Oleg Nesterov's message of
	"Tue, 15 Jul 2014 20:47:53 +0200")
Message-ID: <871ttk2yx4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Tue, 15 Jul 2014 20:47:53 +0200, Oleg Nesterov wrote:
> Hello,
>
> To avoid the confusion, let me resend everything (except the 1st patch
> you already applied) with v2 tag.
>
> Changes:
>
> 	4/7 - fix the typo in changelog, add the ack from Srikar
>
> 	6/7 - by discussion with you and Namhyung: pass dir rather
> 	      then system, update replace_system_preds() as well.
>
> 	7/7 - new, cosmetic/trivial.

Looks all good to me.  You can add my Acked-by if you want. :)

Thanks,
Namhyung
