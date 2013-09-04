Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481Ab3IDTvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:51:38 -0400
Received: from a194-110.smtp-out.amazonses.com ([199.255.194.110]:6655 "EHLO
	a194-110.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755664Ab3IDTvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:51:35 -0400
Date: Wed, 4 Sep 2013 19:51:31 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-arch@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [gcv v3 10/35] rcu: Replace __get_cpu_var uses
In-Reply-To: <20130904194135.GD3966@linux.vnet.ibm.com>
Message-ID: <00000140ea879e64-44399484-986b-47da-be12-5f3cd4da7abb-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com> <00000140c67825ee-d9e3a1ca-2e81-4868-8c8c-36ba965f7202-000000@email.amazonses.com> <20130831203559.GY3871@linux.vnet.ibm.com> <00000140e95815db-41b26a90-9bc9-490e-a313-e05364a152cb-000000@email.amazonses.com>
 <20130904194135.GD3966@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Sep 2013, Paul E. McKenney wrote:

> Yep, still queued for 3.13, and I even redid the change in
> rcu_is_cpu_idle() to be the way you wanted it.  I wouldn't do that for
> just anyone, you know!  ;-)

Well not everyone is so perfect as you are and has a tree for another
version of the kernel ahead of time.

