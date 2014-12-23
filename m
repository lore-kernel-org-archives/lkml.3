Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbaLWKfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:35:03 -0500
Received: from smtp.citrix.com ([66.165.176.89]:2378 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaLWKfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:35:02 -0500
X-IronPort-AV: E=Sophos;i="5.07,631,1413244800"; 
   d="scan'208";a="207328384"
Message-ID: <54994553.6070401@citrix.com>
Date: Tue, 23 Dec 2014 10:34:59 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/time: Remove unnecessary BUG_ON(preemptible())
 in xen_setup_timer()
References: <1419273190-18821-1-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1419273190-18821-1-git-send-email-boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/12/14 18:33, Boris Ostrovsky wrote:
> There is no reason for having it and, with commit 250a1ac685f1 ("x86,
> smpboot: Remove pointless preempt_disable() in
> native_smp_prepare_cpus()"), it prevents HVM guests from booting.

Applied to stable/for-linus-3.19, thanks.

For arch-specific fixes I prefer the arch in the subject. e.g., "x86/xen:".

David
