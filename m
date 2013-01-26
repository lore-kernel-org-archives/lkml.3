Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3AZMSZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 07:18:25 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45637 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3AZMSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 07:18:23 -0500
Date: Sat, 26 Jan 2013 13:18:19 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] sched: add a tuning knob to allow changing RR tmeslice
Message-ID: <20130126121819.GI13445@gmail.com>
References: <20121108195113.2dd51d43@redhat.com>
 <20130124165955.GA9324@gmail.com>
 <20130124135427.1748d057@redhat.com>
 <20130125081916.GC25314@gmail.com>
 <20130125120256.52733b51@redhat.com>
 <20130125183610.GA31022@gmail.com>
 <20130125154353.0d47d334@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125154353.0d47d334@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Would be nice to have a patch against -tip, as we already have 
an interacting change:

 57d2aa00dcec sched/rt: Avoid updating RT entry timeout twice within one tick period

Which creates a conflict.

Thanks,

	Ingo
