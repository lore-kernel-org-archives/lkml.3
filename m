Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab3ILOK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:10:58 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:20397 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034Ab3ILOK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:10:57 -0400
Date: Thu, 12 Sep 2013 14:10:56 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
In-Reply-To: <20130911220228.GB15367@somewhere>
Message-ID: <000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com> <20130911220228.GB15367@somewhere>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Frederic Weisbecker wrote:

> Why not do this from userspace instead?

Because the cpumasks are hardcoded in the kernel code.

