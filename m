Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbaIWNeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:34:44 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36007 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaIWNem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:34:42 -0400
Date: Tue, 23 Sep 2014 14:35:03 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: "bsegall@google.com" <bsegall@google.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] sched: Make sched entity usage tracking
 scale-invariant
Message-ID: <20140923133503.GT23693@e103034-lin>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
 <1411403047-32010-7-git-send-email-morten.rasmussen@arm.com>
 <xm2638bjlgs5.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xm2638bjlgs5.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 06:13:46PM +0100, bsegall@google.com wrote:
> Morten Rasmussen <morten.rasmussen@arm.com> writes:
> 
> > Apply scale-invariance correction factor to usage tracking as well.
> 
> It seems like it would make more sense to order the patches as first the
> usage tracking and then all of the scale-invariance together, or perhaps
> to just fold this into the usage tracking patch.

Makes sense. I don't mind reordering the patches. Vincent has already
got some of the usage bits in his patch set, so I will have to rework
the usage patches anyway if Peter decides to take the rest of Vincent's
patch set.

Morten
