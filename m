Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaJ0OHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:07:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48022 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaJ0OHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:07:35 -0400
Date: Mon, 27 Oct 2014 15:07:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Marcel Holtmann <marcel@holtmann.org>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [rfcomm_run] WARNING: CPU: 0 PID: 95 at kernel/sched/core.c:7312
 __might_sleep()
Message-ID: <20141027140726.GJ3337@twins.programming.kicks-ass.net>
References: <20141027130621.GA6336@wfg-t540p.sh.intel.com>
 <20141027133627.GH3337@twins.programming.kicks-ass.net>
 <20141027134948.GA8977@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027134948.GA8977@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 09:49:48PM +0800, Fengguang Wu wrote:
> On Mon, Oct 27, 2014 at 02:36:27PM +0100, Peter Zijlstra wrote:
> > On Mon, Oct 27, 2014 at 09:06:21PM +0800, Fengguang Wu wrote:
> > > Hi Peter,
> > > 
> > > FYI, this bug seems still there on v3.18-rc2.
> > 
> > Oh, right, I commented out that patch and the audit one because I was
> > waiting for some feedback. Lemme go prod people.
> 
> audit? I do hit an kauditd_thread warning recently:

Yep that one, see:
http://lkml.kernel.org/r/20141027134103.GA10476@twins.programming.kicks-ass.net
