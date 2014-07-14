Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbaGNUMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:12:10 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52682 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749AbaGNUMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:12:07 -0400
Date: Mon, 14 Jul 2014 13:10:05 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Christoph Lameter <cl@gentwo.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, akpm@linux-foundation.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: vmstat: On demand vmstat workers V8
In-Reply-To: <alpine.DEB.2.11.1407111022320.26485@gentwo.org>
Message-ID: <alpine.LSU.2.11.1407141306150.17828@eggly.anvils>
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org> <20140711132032.GB26045@localhost.localdomain> <alpine.DEB.2.11.1407110855030.25432@gentwo.org> <20140711135854.GD26045@localhost.localdomain> <alpine.DEB.2.11.1407111016040.26485@gentwo.org>
 <20140711151935.GE26045@localhost.localdomain> <alpine.DEB.2.11.1407111022320.26485@gentwo.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Christoph Lameter wrote:
> On Fri, 11 Jul 2014, Frederic Weisbecker wrote:
> 
> > Maybe just merge both? The whole looks good.
> 
> I hope so. Andrew?

I hope so, too: I know there are idle feckless^Htickless people
eager for it.  I did take the briefest of looks, but couldn't
really find any mm change to ack or otherwise: if Frederic is
happy with it now, seems good to go.

Hugh
