Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaDPEPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:15:07 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:62079 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDPEPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:15:04 -0400
Date: Wed, 16 Apr 2014 00:18:11 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1404152242560.17451@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1404160014370.17661@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1404152348160.22697@ionos.tec.linutronix.de> <alpine.DEB.2.10.1404152242560.17451@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Vince Weaver wrote:

> Possibly it looks like a struct perf_event is being used after freed,
> specifically the event->migrate_entry->prev value?  I could
> be completely wrong about that.

and actually I'm mixing up hex and decimal.  It looks like the actual 
value being written to the freed area is at 0x48 whichi I think maps to
	event->hlist_entry->pprev

but really if it's late enough I'm mixing hex and decimal I should 
probably stop staring at trace dumps and get some sleep.

Vince


