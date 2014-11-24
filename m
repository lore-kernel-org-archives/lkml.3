Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaKXPiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:38:19 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38168 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaKXPiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:38:17 -0500
Date: Mon, 24 Nov 2014 15:39:11 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Paul Turner <pjt@google.com>, Ben Segall <bsegall@google.com>
Subject: Re: [PATCH v9 02/10] sched: Track group sched_entity usage
 contributions
Message-ID: <20141124153911.GJ23177@e105550-lin.cambridge.arm.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
 <1415033687-23294-3-git-send-email-vincent.guittot@linaro.org>
 <20141121123509.GC23177@e105550-lin.cambridge.arm.com>
 <CAKfTPtBZWDSWVYQ9VE8=rsnsb2kLyUAsc5d_bvcypXE2JgarYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtBZWDSWVYQ9VE8=rsnsb2kLyUAsc5d_bvcypXE2JgarYQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 02:04:21PM +0000, Vincent Guittot wrote:
> On 21 November 2014 at 13:35, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> > What happened to the update of se->avg.utilization_avg_contrib in
> > __synchronize_entity_decay()? It seems to have disapperead after v7.
> 
> It was moved in patch 1 where it is is right place

Ahh... I missed that :)
