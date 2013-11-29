Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab3K2NoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:44:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab3K2NoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:44:14 -0500
Date: Fri, 29 Nov 2013 14:44:10 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v3 1/4] perf diff: color the Delta column
Message-ID: <20131129134410.GB25751@krava.brq.redhat.com>
References: <1385550154-11385-1-git-send-email-artagnon@gmail.com>
 <1385550154-11385-2-git-send-email-artagnon@gmail.com>
 <20131128150710.GE1245@krava.brq.redhat.com>
 <CALkWK0nr9v5P5sO6UDCMr73i5r+PYaS1Da8vST9aUcHZnqv8JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0nr9v5P5sO6UDCMr73i5r+PYaS1Da8vST9aUcHZnqv8JQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 10:54:25PM +0530, Ramkumar Ramachandra wrote:
> Jiri Olsa wrote:
> > these colors are not consistent with colors in baseline,
> > moreover all negative values are shown as red
> >
> > - please check get_percent_color function (used for baseline),
> >   it checks the percentage against following values:
> >
> >   #define MIN_GREEN       0.5
> >   #define MIN_RED         5.0
> 
> That was intentional. If you want colors that are consistent with the
> baseline, what do we do about [4/4], where wdiff numbers can be huge?
> (currently I use [green, red] for [positive, negative] there too)

you're, ratio and wdiff need special treatment..

but I expect delta to be have same colors as baseline
(regardless of the +-)

thanks,
jirka
