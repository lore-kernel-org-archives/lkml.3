Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbaGWGvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:51:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:35559 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbaGWGvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:51:09 -0400
Date: Wed, 23 Jul 2014 08:51:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Bruno Wolff III <bruno@wolff.to>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140723065104.GL3935@laptop>
References: <20140721165212.GO3935@laptop>
 <20140722094740.GJ12054@laptop.lan>
 <20140722103857.GK12054@laptop.lan>
 <20140722121001.GA30631@wolff.to>
 <20140722130343.GD3935@laptop>
 <20140722132603.GL12054@laptop.lan>
 <20140722133514.GM12054@laptop.lan>
 <20140722140912.GA23406@wolff.to>
 <20140722141855.GG3935@laptop>
 <20140723013719.GA2000@wolff.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723013719.GA2000@wolff.to>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 08:37:19PM -0500, Bruno Wolff III wrote:
>                build_sched_domain: cpu: 0 level: SMT cpu_map: 0-3 tl->mask: 0,2
> [    0.252441] build_sched_domain: cpu: 0 level: MC cpu_map: 0-3 tl->mask: 0,2
> [    0.252526] build_sched_domain: cpu: 0 level: DIE cpu_map: 0-3 tl->mask: 0-3

W00t! that seems to have cured it.

Thanks Bruno, I'll go write up a proper changelog and such.
