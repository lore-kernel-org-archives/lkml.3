Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaJQMqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:46:15 -0400
Received: from smtp.citrix.com ([66.165.176.89]:46942 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbaJQMqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:46:11 -0400
X-IronPort-AV: E=Sophos;i="5.04,739,1406592000"; 
   d="scan'208";a="182321741"
Message-ID: <54410F90.3070206@citrix.com>
Date: Fri, 17 Oct 2014 13:46:08 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Martin Kelly <martin@martingkelly.com>, <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <mingo@redhat.com>, Martin Kelly <martkell@amazon.com>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] x86/xen: panic on bad Xen-provided memory
 map
References: <1413517692-17727-1-git-send-email-martin@martingkelly.com>
In-Reply-To: <1413517692-17727-1-git-send-email-martin@martingkelly.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/14 04:48, Martin Kelly wrote:
> Panic if Xen provides a memory map with 0 entries. Although this is
> unlikely, it is better to catch the error at the point of seeing the map
> than later on as a symptom of some other crash.

Applied, thanks.

David
