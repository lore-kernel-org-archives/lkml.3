Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab3JHMfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:35:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab3JHMfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:35:31 -0400
Message-ID: <1381235727.15686.41.camel@marge.simpson.net>
Subject: Re: perf: perf sched lat segfault - bisected
From: Mike Galbraith <bitbucket@online.de>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 08 Oct 2013 14:35:27 +0200
In-Reply-To: <1381235260.15686.38.camel@marge.simpson.net>
References: <1381221715.15686.3.camel@marge.simpson.net>
	 <20131008121709.GA3955@infradead.org>
	 <1381235260.15686.38.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:PcBSIKSk44arTQPbEBwJ6/3KZ0lPDlXJoXH5II9Ff26
 R3+G1+QKMHeMjrrFtSy9Fdd0GXZ7PgqWOTRmc3mGErxTdRCHBT
 OwSuT8pERhJySeh+R4bFtkwAe1WSNaHESmYyUnpLt/E6gWO8VQ
 beLlRSSqePy0KUNcqvoA22S9wD2IRaeVTSmi5AhZWgyNhGDccv
 PUjI1CXRMYezz+aIBFPC1zEIZ3Szba2JutDVgWodibg3+BntGz
 c/biGwUtjkREDn45Pz7FvZNGpvpleGNEini0I2DcVz3sCrBtFU
 sGNiGb4cRAPI3gDhljwApNshkwFUEBz4EdEvgtzKFFxvu2wuOk
 thsudojT+vxXtaykX33LEkJEv/mGjy79fQfXv+cCw4Q8xtKwxI
 tT/By9/Ff7PvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 14:27 +0200, Mike Galbraith wrote: 
> On Tue, 2013-10-08 at 09:17 -0300, Arnaldo Carvalho de Melo wrote: 
> > Em Tue, Oct 08, 2013 at 10:41:55AM +0200, Mike Galbraith escreveu:
> > > Box: Q6600
> > > 
> > > Reproducer:
> > > perf sched record -- sleep 1
> > > perf sched lat (boom)
> > > 
> > > The bisect winner:
> > 
> > Can you try with today's tip/perf/urgent branch?
> 
> Works fine.

(except replay segfaults, but lord knows when that last worked)

