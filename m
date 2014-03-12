Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaCLDMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 23:12:06 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:5227 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752771AbaCLDME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 23:12:04 -0400
Date: Tue, 11 Mar 2014 23:11:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Waiman Long <waiman.long@hp.com>,
        arnd@arndb.de, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        walken@google.com, andi@firstfloor.org, riel@redhat.com,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        oleg@redhat.com
Subject: Re: [RFC][PATCH 0/7] locking: qspinlock
Message-ID: <20140311231159.25a0d8dc@gandalf.local.home>
In-Reply-To: <20140312023153.GW13647@dastard>
References: <20140310154236.038181843@infradead.org>
	<20140312023153.GW13647@dastard>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 13:31:53 +1100
Dave Chinner <david@fromorbit.com> wrote:


> So either this patchset doesn't work right now, or there's something
> else broken in the tip/master tree...

I've found a few things broken with the tip master tree. Anyway, I'm
not sure the patches are even there. The last I saw, the patches are
still in RFC stage. Might want to take a known working kernel and apply
the patches manually.

-- Steve
