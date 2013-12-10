Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab3LJUCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:02:51 -0500
Received: from a14-6.smtp-out.amazonses.com ([54.240.14.6]:43241 "EHLO
	a14-6.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881Ab3LJUCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:02:48 -0500
Date: Tue, 10 Dec 2013 20:02:46 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/41] percpu: Add raw_cpu_ops
In-Reply-To: <20131210183133.GC20770@gmail.com>
Message-ID: <00000142de1ac9a3-d2b5b7fb-25c5-4bec-acbe-8be30a951bbc-000000@email.amazonses.com>
References: <20131203233232.928771708@linux.com> <20131203233251.745099192@linux.com> <20131210153445.GE4610@htj.dyndns.org> <20131210154506.GA1884@gmail.com> <20131210154951.GF4610@htj.dyndns.org> <20131210155546.GD1995@gmail.com>
 <00000142ddb6d07d-f77cfa15-55a5-4806-891e-2d57894fc46b-000000@email.amazonses.com> <20131210183133.GC20770@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.10-54.240.14.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Ingo Molnar wrote:

> By what is this required - by the previous patch #13?

Yes its required in order to keep the __this_cpu ops working.

> Also, the changelog indicates it's two changes - please split the
> patch in two if so.

Well this is how the x86 portions came from Peter. Patch can be split
according to the file modified in x86.

