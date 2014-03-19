Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842AbaCSL1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:27:35 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:44688 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602AbaCSL1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:27:33 -0400
Message-ID: <1395228430.4896.6.camel@marge.simpson.net>
Subject: Re: Thread Scheduler
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 19 Mar 2014 12:27:10 +0100
In-Reply-To: <1395223046.28757.YahooMailNeo@web141601.mail.bf1.yahoo.com>
References: <1395223046.28757.YahooMailNeo@web141601.mail.bf1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 02:57 -0700, Mahmood Naderan wrote: 
> 
> Hi
> Maybe this is a noob question...
> Where in the linux kernel source (2.6), the 
> 
> thread scheduler has been implemented? Searching 
> 
> the web shows that there should sched_fair.c but 
> 
> I can not find that in the source directory (the 
> kernel source has been installed). 

The scheduler recently moved to kernel/sched directory.  For older
kernels, it's kernel/sched_*.

-Mike

