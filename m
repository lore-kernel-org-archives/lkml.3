Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbaISWY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 18:24:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59114 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485AbaISWYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 18:24:24 -0400
Message-ID: <541CAD16.6030309@codeaurora.org>
Date: Fri, 19 Sep 2014 15:24:22 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>, LKML <linux-kernel@vger.kernel.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-api@vger.kernel.org, linux390@de.ibm.com,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v4 04/11] drivers: base: support cpu cache information
 interface to userspace via sysfs
References: <1409763617-17074-1-git-send-email-sudeep.holla@arm.com> <1409763617-17074-5-git-send-email-sudeep.holla@arm.com>
In-Reply-To: <1409763617-17074-5-git-send-email-sudeep.holla@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/14 10:00, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
>
> This patch adds initial support for providing processor cache information
> to userspace through sysfs interface. This is based on already existing
> implementations(x86, ia64, s390 and powerpc) and hence the interface is
> intended to be fully compatible.
>
> The main purpose of this generic support is to avoid further code
> duplication to support new architectures and also to unify all the existing
> different implementations.
>
> This implementation maintains the hierarchy of cache objects which reflects
> the system's cache topology. Cache devices are instantiated as needed as
> CPUs come online. The cache information is replicated per-cpu even if they are
> shared. A per-cpu array of cache information maintained is used mainly for
> sysfs-related book keeping.
>
> It also implements the shared_cpu_map attribute, which is essential for
> enabling both kernel and user-space to discover the system's overall cache
> topology.
>
> This patch also add the missing ABI documentation for the cacheinfo sysfs
> interface already, which is well defined and widely used.
>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: linux-api@vger.kernel.org
> Cc: linux390@de.ibm.com
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-ia64@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-s390@vger.kernel.org
> Cc: x86@kernel.org
>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Tested-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

