Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbbAOKnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:43:47 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:39789 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbbAOKno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:43:44 -0500
X-IronPort-AV: E=Sophos;i="5.09,402,1418083200"; 
   d="scan'208";a="217195356"
Message-ID: <54B799DC.1050008@citrix.com>
Date: Thu, 15 Jan 2015 10:43:40 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
        <kvm-ppc@vger.kernel.org>, <linux-mm@kvack.org>,
        <xen-devel@lists.xenproject.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [Xen-devel] [PATCH 3/8] x86/xen/p2m: Replace ACCESS_ONCE with
 READ_ONCE
References: <1421312314-72330-1-git-send-email-borntraeger@de.ibm.com> <1421312314-72330-4-git-send-email-borntraeger@de.ibm.com>
In-Reply-To: <1421312314-72330-4-git-send-email-borntraeger@de.ibm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/15 08:58, Christian Borntraeger wrote:
> ACCESS_ONCE does not work reliably on non-scalar types. For
> example gcc 4.6 and 4.7 might remove the volatile tag for such
> accesses during the SRA (scalar replacement of aggregates) step
> (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)
> 
> Change the p2m code to replace ACCESS_ONCE with READ_ONCE.

Acked-by: David Vrabel <david.vrabel@citrix.com>

Let me know if you want me to merge this via the Xen tree.

David
