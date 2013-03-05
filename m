Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3CEMEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 07:04:22 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:46725 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3CEMEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 07:04:21 -0500
Date: Tue, 5 Mar 2013 13:04:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Anton Arapov <anton@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v4 0/6] uprobes: return probe implementation
Message-ID: <20130305120417.GA25562@gmail.com>
References: <1362407893-32505-1-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362407893-32505-1-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anton Arapov <anton@redhat.com> wrote:

> Hello,
> 
>   RFC v4 uretprobes implementation. I'd be grateful for review.
>   /* Oleg, this one is more quirky than previous, don't beat me. */

Please include a good high level description of the new feature in one of the 
patches - preferably also stick it somewhere into Documentation/.

Thanks,

	Ingo
