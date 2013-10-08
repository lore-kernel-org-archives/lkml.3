Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3JHKmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:42:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64280 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab3JHKlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:41:15 -0400
Message-ID: <1381228870.15686.15.camel@marge.simpson.net>
Subject: Re: perf: perf sched lat segfault - bisected
From: Mike Galbraith <bitbucket@online.de>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 08 Oct 2013 12:41:10 +0200
In-Reply-To: <CABPqkBQD9TE7RbP-auXO060aU1QNU=RUw2QZvoF39CCqpzdC4w@mail.gmail.com>
References: <1381221715.15686.3.camel@marge.simpson.net>
	 <CABPqkBRMa7rawfvQ2Sunc2tr87s_WqT_7GYac6+x=SNZoJSueg@mail.gmail.com>
	 <1381227252.15686.9.camel@marge.simpson.net>
	 <1381227659.15686.11.camel@marge.simpson.net>
	 <CABPqkBQD9TE7RbP-auXO060aU1QNU=RUw2QZvoF39CCqpzdC4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:XCU169HhD4eIaZ21PwKFndxbHp3KcDBojkJMYp6WHk3
 azPad2nLxF5/LsNJywUFsE2dsxFiTfYBUiTQVCVGwvtF1OSD9H
 dE66nh9V7uTqDTPoklpn6Ezh4yX6fxnGHvBVWFkSwCZt0F+c8Z
 gRVVdu+Yi6O6fv2/ftV1Gsv58MVHHVO2HNYZpaZPSCTrAUi8sS
 xTbUpTJdLnPCSrgVt9AWLTmITZ5vdFSGnzPlwWY/G9lwUeB2jy
 M70XMuYVN32DUB398HRAAhE+gEfUl2GsZ0sy+rvY0IHY0QOVqn
 wKA4moiQRzYlyqPDQIbuOPO7y1hv0fWsKrlFsbjpZH3cEf3n+L
 F6m63cJ1DhNwH4mT6eNR3bx/muMyL7gG9BXO9ulOMUyzg0SfKX
 2fFSqdyLmzJjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 12:25 +0200, Stephane Eranian wrote: 
> Mike,
> 
> Ok, I missed the sched record, let me track this down.
> Note that there was a second commit to fix this one
> by Arnaldo. Do you also have it in your kernel?
> 
> 51131c4 perf: Fix up MMAP2 buffer space reservation

Not with that commit id, but..

commit d008d5258e9c1a1b7ee6547b8d444323aef331b3
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Tue Sep 10 10:24:05 2013 -0300

    perf: Fix up MMAP2 buffer space reservation

-Mike

