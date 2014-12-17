Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaLQMfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 07:35:51 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46650 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQMft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 07:35:49 -0500
Date: Wed, 17 Dec 2014 13:35:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, acme@redhat.com,
        dsahern@gmail.com, dzickus@redhat.com, rfowles@redhat.com,
        jmario@redhat.com, namhyung@kernel.org
Subject: Re: [PATCH v2] perf mem: enable simultaneous sampling of loads/stores
Message-ID: <20141217123544.GA23555@gmail.com>
References: <20141216211427.GA23877@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216211427.GA23877@thinkpad>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> 
> This patch modifies perf mem to default to smapling loads

s/smapling/sampling

> and stores simultaneously. It could only do one or the other
> before yet there was not hardware restriction preventing
> simultaneous collection. With this patch, one run is sufficient
> to collect both.
> 
> It is still possible to smaple only loads or stores by using the

s/smaple/sample

Thanks,

	Ingo
