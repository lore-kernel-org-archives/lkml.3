Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab3JNPsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:48:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33143 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab3JNPsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:48:43 -0400
Date: Mon, 14 Oct 2013 17:47:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <aarapov@redhat.com>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] uprobes: Change uprobe_copy_process() to dup xol_area
Message-ID: <20131014154732.GA19847@dyad.arnhem.chello.nl>
References: <20131013191815.GA32466@redhat.com>
 <20131013191844.GA32502@redhat.com>
 <20131014140942.GI28601@twins.programming.kicks-ass.net>
 <20131014145539.GA4319@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014145539.GA4319@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 04:55:39PM +0200, Oleg Nesterov wrote:
> So will you agree with task_work for now?

oh sure, these suggestions were more a where next thing. because
 the current state is very much undesirable any which way. 
