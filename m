Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaJQMpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:45:51 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:37953 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbaJQMpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:45:49 -0400
X-IronPort-AV: E=Sophos;i="5.04,739,1406592000"; 
   d="scan'208";a="183523749"
Message-ID: <54410F7B.6040803@citrix.com>
Date: Fri, 17 Oct 2014 13:45:47 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <konrad.wilk@oracle.com>
CC: <cl@linux.com>, <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH] xen/time: Fix incorrect per_cpu accessor
 in xen_clocksource_read()
References: <1413493335-6110-1-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1413493335-6110-1-git-send-email-boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/14 22:02, Boris Ostrovsky wrote:
> Commit 89cbc76768c2 ("x86: Replace __get_cpu_var uses") replaced
> __get_cpu_var() with this_cpu_ptr() in xen_clocksource_read() in such a
> way that instead of accessing a structure pointed to by a per-cpu pointer
> we are trying to get to a per-cpu structure.
> 
> __this_cpu_read() of the pointer is the more appropriate accessor.

Applied, thanks.

David
