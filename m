Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaEWNkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:40:05 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:57425 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaEWNkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:40:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140523102042.GA7267@mwanda>
References: <20140523102042.GA7267@mwanda>
Date: Fri, 23 May 2014 19:10:02 +0530
X-Google-Sender-Auth: h85EsnI6LqXrT6OLDPfXyjlShqI
Message-ID: <CAC4Lta3+GHLEMYNHsvx4vsN557vFdrBO_ROo8mN4JpG3T3ejJg@mail.gmail.com>
Subject: Re: [patch] sched: signedness bug in yield_to()
From: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 3:50 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> yield_to() is supposed to return -ESRCH if there is no task to
> yield to, but because the type is bool that is the same as returning
> true.
>
> The only place I see which cares is kvm_vcpu_on_spin().
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks,  Please feel free to add
Reviewed-by: Raghavendra <raghavendra.kt@linux.vnet.ibm.com>
