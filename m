Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaJBUDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 16:03:16 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:52447 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJBUDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 16:03:15 -0400
Date: Thu, 2 Oct 2014 13:03:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Lothian <mike@fireburn.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hard lockups under high CPU load with DynTicks - RCU Related?
Message-ID: <20141002200307.GW5015@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAHbf0-HyGUPcc14HwBjmQnQV9Mauxur3=5O_MqyGmiV9NK4Pnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHbf0-HyGUPcc14HwBjmQnQV9Mauxur3=5O_MqyGmiV9NK4Pnw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100220-0928-0000-0000-000005574DD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 08:32:02AM +0100, Mike Lothian wrote:
> Hi
> 
> I've raised https://bugzilla.kernel.org/show_bug.cgi?id=84131 and
> attempted to bisect
> 
> The bug I'm stumbling on happens on both and Intel Sandybridge and AMD
> Kabini system - it manifests itself as a hard lockup when the system
> is under high load
> 
> If I switch off DynTicks the problem doesn't happen - I bisected by
> compiling Chromium marking each one good or bad if the system starts
> to lockup
> 
> I'm not sure if I've filed the bug under the right Product / Component
> 
> Please let me know if you'd like any more diagnostics

The commit that your bisection located is a merge commit.  Could you
please try each of the branches that were merged?  That might allow
you to pinpoint the actual commit.

							Thanx, Paul

