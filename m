Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaFZTXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:23:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbaFZTXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:23:11 -0400
Date: Thu, 26 Jun 2014 21:22:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tzanussi@gmail.com, jolsa@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf script/python: Print array argument as
 string
Message-ID: <20140626192258.GA1139@krava.redhat.com>
References: <1401338695-18837-1-git-send-email-namhyung@kernel.org>
 <tip-e646fe730a324098a718f1c9b2f349efb99d5457@git.kernel.org>
 <53AC3E37.1010603@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AC3E37.1010603@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 05:37:27PM +0200, Sebastian Andrzej Siewior wrote:
> On 06/12/2014 02:01 PM, tip-bot for Namhyung Kim wrote:
> 
> > Commit-ID:  e646fe730a324098a718f1c9b2f349efb99d5457
> > Gitweb:     http://git.kernel.org/tip/e646fe730a324098a718f1c9b2f349efb99d5457
> > Author:     Namhyung Kim <namhyung@kernel.org>
> > AuthorDate: Thu, 29 May 2014 13:44:55 +0900
> > Committer:  Jiri Olsa <jolsa@kernel.org>
> > CommitDate: Mon, 9 Jun 2014 12:21:03 +0200
> > 
> > perf script/python: Print array argument as string
> > 
> > With the Sebastian's change of handling num array argument (of raw
> > syscall enter), the script still failed to work like this:
> 
> This patch got merged. It fixes something that was introduced by
>   "perf script: move the number processing into its own function" [0]
>   "perf script: handle the num array type in python properly" [1]
> 
> which was not yet merged.

yea, we are fast.. fixing bugs even before making them ;-)

I'll check/queue those 2

thanks,
jirka
