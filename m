Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaBUXbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:31:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:44577 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaBUXbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:31:19 -0500
Date: Sat, 22 Feb 2014 00:31:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dan Williams <dan.j.williams@intel.com>
cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Mike Galbraith <bitbucket@online.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] ioat: fix tasklet tear down
In-Reply-To: <CAPcyv4h0iHXt5jioOt=WMmrobJ-6Si2SALxGZoibJphB2=+XkQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402220030560.21251@ionos.tec.linutronix.de>
References: <20140220071145.21609.89019.stgit@viggo.jf.intel.com> <alpine.DEB.2.02.1402201102290.4468@ionos.tec.linutronix.de> <CAPcyv4h0iHXt5jioOt=WMmrobJ-6Si2SALxGZoibJphB2=+XkQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Dan Williams wrote:
> On Thu, Feb 20, 2014 at 2:30 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > That's 18 of 30 usage sites. Impressive....
> >
> > We need to poke the relevant maintainers to get this solved.
> >
> 
> Maybe also rename tasklet_disable() to tasklet_pause() to make it
> clearer "this isn't the tasklet cleanup routine you're looking for"?

Indeed.

 
