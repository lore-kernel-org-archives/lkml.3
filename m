Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaFCMEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:04:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbaFCMD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:03:59 -0400
Date: Tue, 3 Jun 2014 14:03:45 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, jean.pihet@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix 'make help' message error
Message-ID: <20140603120345.GB2864@krava.brq.redhat.com>
References: <87egz6emef.fsf@sejong.aot.lge.com>
 <1401765031-29555-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401765031-29555-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 11:10:31AM +0800, Jianyu Zhan wrote:
> Hi, Namhyung,
> 
> On Tue, Jun 3, 2014 at 10:51 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> >
> > s/condiered/considered/ ?
> >
> >
> 
> Oops, sorry for the typo.
> 
> >>> has an empty value, so "prefix" is honored. However, "prefix" is unconditionally
> >>> assigned to $HOME, regardless of what it is set to from command line. So our
> >>> "prefix" setting got no respect and the actual destination falls back to $HOME.
> >>>
> >>> This patch fixes this issue and corrects the help message.
> >
> > With that changed,
> >
> > Acked-by: Namhyung Kim <namhyung@kernel.org>
> 
> Thanks. I renew the patch for maintainers to pick up.

queued.. thanks,

jirka
