Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaJGRY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:24:28 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:18938 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaJGRY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:24:27 -0400
X-IronPort-AV: E=Sophos;i="5.04,671,1406592000"; 
   d="scan'208";a="180192216"
Message-ID: <543421C2.709@citrix.com>
Date: Tue, 7 Oct 2014 18:24:18 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Ted Percival <ted@tedp.id.au>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "moderated list:XEN HYPERVISOR IN..." 
	<xen-devel@lists.xenproject.org>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/xen: Fix build failure without CONFIG_XEN_PVH
References: <1412700924-2662-1-git-send-email-ted@tedp.id.au>
In-Reply-To: <1412700924-2662-1-git-send-email-ted@tedp.id.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/14 17:55, Ted Percival wrote:
> Fixes: 851861bb4cc0 ("x86/xen: Set EFER.NX and EFER.SCE in PVH guests")
> Signed-off-by: Ted Percival <ted@tedp.id.au>

I've already pushed a fixed version to linux-next.

Thanks.

David
