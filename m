Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3IYWmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:42:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44619 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab3IYWmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:42:05 -0400
Date: Wed, 25 Sep 2013 15:41:47 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 08/21] perf: Add new 'paused' attribute
Message-ID: <20130925224147.GB13425@us.ibm.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
 <1380113447-17144-9-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380113447-17144-9-git-send-email-jolsa@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092522-7182-0000-0000-00000886EEB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@redhat.com] wrote:
| Adding new 'paused' perf_event_attr attribute bit. It sets
| the initial event state as paused, so it wont get started
| until it's triggered by toggling mechanism.

There is a attr->disabled field which also leaves the event off by
default.  Some comments distinguishing the two states will help ?

Sukadev

