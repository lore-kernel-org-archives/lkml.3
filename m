Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965571Ab3FTN6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:58:31 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:44408 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965093Ab3FTN62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:58:28 -0400
Date: Thu, 20 Jun 2013 13:58:27 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 2/2] mm: add sysctl to pick vmstat monitor cpu
In-Reply-To: <1371672168-9869-2-git-send-email-gilad@benyossef.com>
Message-ID: <0000013f61e10d68-d5ca253d-d14f-4547-8291-aafa6b596ed7-000000@email.amazonses.com>
References: <CAOtvUMc5w3zNe8ed6qX0OOM__3F_hOTqvFa1AkdXF0PHvzGZqg@mail.gmail.com> <1371672168-9869-2-git-send-email-gilad@benyossef.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.06.20-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013, Gilad Ben-Yossef wrote:

> Add a sysctl knob to enable admin to hand pick the scapegoat cpu
> that will perform the extra work of preiodically checking for
> new VM activity on CPUs that have switched off their vmstat_update
> work item schedling.

Not necessary if we use the dynticks sacrificial processor
(boot cpu). Seems to be also used for RCU.

