Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaBCKsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:48:08 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50453 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbaBCKsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:48:06 -0500
Date: Mon, 3 Feb 2014 10:46:41 +0000
From: Will Deacon <will.deacon@arm.com>
To: Adrien =?iso-8859-1?Q?Verg=E9?= <adrienverge@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Christopher Covington <cov@codeaurora.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Michel Dagenais <michel.dagenais@polymtl.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 5/5] ARM CoreSight: ETM: Add PID control support
Message-ID: <20140203104641.GB12187@mudshark.cambridge.arm.com>
References: <1391098270-8867-1-git-send-email-adrienverge@gmail.com>
 <1391098270-8867-6-git-send-email-adrienverge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391098270-8867-6-git-send-email-adrienverge@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 04:11:10PM +0000, Adrien Vergé wrote:
> In the same manner as for enabling tracing, an entry is created in
> sysfs to set the PID that triggers tracing. This change is effective
> only if CONFIG_PID_IN_CONTEXTIDR is set.
> 
> When using PID namespaces, the virtual PID given by the user is
> converted to the globally unique ID (task_pid_nr) that is present
> in the Context ID register.

Hmm, I wonder whether debugfs would be more suitable for this?

Will
