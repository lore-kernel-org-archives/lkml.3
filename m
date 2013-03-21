Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab3CUVCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:02:41 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:3123 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753297Ab3CUVCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:02:40 -0400
Date: Thu, 21 Mar 2013 21:02:37 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        zhong@linux.vnet.ibm.com, khilman@linaro.org, geoff@infradead.org,
        tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
In-Reply-To: <CAFTL4hywucK7_d2V-wYkhagu0+izYz_MTFNJEHEsaTvoZBXwMg@mail.gmail.com>
Message-ID: <0000013d8ec2b268-851c8d6d-c4d1-42fb-b0e1-e1b90de7d911-000000@email.amazonses.com>
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com> <1363636794.15703.32@driftwood> <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com> <20130318222548.GG3656@linux.vnet.ibm.com> <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com> <0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com> <20130321171518.GW3637@linux.vnet.ibm.com> <0000013d8e3f58ce-0f6ea95f-780a-49c1-a633-5aa0cf3e5040-000000@email.amazonses.com>
 <20130321185821.GF3637@linux.vnet.ibm.com> <0000013d8e8d24fd-d2931c45-2722-46d1-8b47-2ef11e21096d-000000@email.amazonses.com> <CAFTL4hywucK7_d2V-wYkhagu0+izYz_MTFNJEHEsaTvoZBXwMg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013, Frederic Weisbecker wrote:

> Sure, for now just don't use SCHED_FIFO and you will have a much more
> extended dynticks coverage.

Ah. Ok. Important information. That would mean no tick for the 2 second
intervals between the vm stats etc. Much much better than now where we
have a tick 1000 times per second.

