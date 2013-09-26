Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab3IZMYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:24:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728Ab3IZMYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:24:53 -0400
Date: Thu, 26 Sep 2013 14:24:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 08/21] perf: Add new 'paused' attribute
Message-ID: <20130926122432.GC1067@krava.brq.redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
 <1380113447-17144-9-git-send-email-jolsa@redhat.com>
 <20130925224147.GB13425@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925224147.GB13425@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 03:41:47PM -0700, Sukadev Bhattiprolu wrote:
> Jiri Olsa [jolsa@redhat.com] wrote:
> | Adding new 'paused' perf_event_attr attribute bit. It sets
> | the initial event state as paused, so it wont get started
> | until it's triggered by toggling mechanism.
> 
> There is a attr->disabled field which also leaves the event off by
> default.  Some comments distinguishing the two states will help ?

right, so the 'disabled' says the event is created as disabled

the 'paused' says the event is enabled, it get's scheduled in/out
but it's does not get started.. toggle event will do that

I'll put more info on that into doc

thanks,
jirka
