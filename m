Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaIHRfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:35:51 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:20701 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbaIHRfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:35:50 -0400
X-IronPort-AV: E=Sophos;i="5.04,487,1406592000"; 
   d="scan'208";a="170199880"
Message-ID: <540DE8F0.8040303@citrix.com>
Date: Mon, 8 Sep 2014 18:35:44 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>
CC: <mingo@redhat.com>, <david.vrabel@citrix.com>, <hpa@zytor.com>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] xen/efi: Directly include needed headers
References: <1410182538-18783-1-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1410182538-18783-1-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/14 14:22, Daniel Kiper wrote:
> I discovered that some needed stuff is defined/declared in headers
> which are not included directly. Currently it works but if somebody
> remove required headers from currently included headers then build
> will break. So, just in case directly include all needed headers.

Seems rather pointless, but harmless.

Applied to devel/for-linus-3.18

Thanks.

David
