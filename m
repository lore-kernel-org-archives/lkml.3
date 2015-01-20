Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbbATTuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:50:09 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:22286 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbbATTuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:50:07 -0500
X-IronPort-AV: E=Sophos;i="5.09,436,1418083200"; 
   d="scan'208";a="219937847"
Message-ID: <54BEAA9D.5090303@citrix.com>
Date: Tue, 20 Jan 2015 19:21:01 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Imre Palik <imrep.amz@gmail.com>, <xen-devel@lists.xenproject.org>,
        David Vrabel <david.vrabel@citrix.com>
CC: "Palik, Imre" <imrep@amazon.de>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Anthony Liguori <aliguori@amazon.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] xen-time: decreasing the rating of the xen
 clocksource below that of the tsc clocksource for dom0's
References: <1421136862-15083-1-git-send-email-imrep.amz@gmail.com>
In-Reply-To: <1421136862-15083-1-git-send-email-imrep.amz@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/15 08:14, Imre Palik wrote:
> From: "Palik, Imre" <imrep@amazon.de>
> 
> In Dom0's the use of the TSC clocksource (whenever it is stable enough to
> be used) instead of the Xen clocksource should not cause any issues, as
> Dom0 VMs never live-migrated.  The TSC clocksource is somewhat more
> efficient than the Xen paravirtualised clocksource, thus it should have
> higher rating.
> 
> This patch decreases the rating of the Xen clocksource in Dom0s to 275.
> Which is half-way between the rating of the TSC clocksource (300) and the
> hpet clocksource (250).

Applied to devel/for-linus-3.20, thanks.

David
