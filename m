Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaG1NMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:12:08 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:28504 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaG1NMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:12:05 -0400
X-IronPort-AV: E=Sophos;i="5.01,749,1400025600"; 
   d="scan'208";a="156890989"
Message-ID: <53D64C1E.8020508@citrix.com>
Date: Mon, 28 Jul 2014 14:11:58 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>
CC: <andrew.cooper3@citrix.com>, <boris.ostrovsky@oracle.com>, <hpa@zytor.com>,
        <ian.campbell@citrix.com>, <jbeulich@suse.com>, <jeremy@goop.org>,
        <konrad.wilk@oracle.com>, <matt.fleming@intel.com>, <mingo@redhat.com>,
        <stefano.stabellini@eu.citrix.com>, <tglx@linutronix.de>
Subject: Re: [PATCH v2 1/2] xen: Silence compiler warnings
References: <1405199388-5692-1-git-send-email-daniel.kiper@oracle.com> <1405199388-5692-2-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1405199388-5692-2-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/14 22:09, Daniel Kiper wrote:
> Add inline keyword to silence the following compiler
> warnings if xen_efi_probe() is not used:

The title and should be:

    xen: make stub xen_efi_probe() static inline

    Empty stub functions in headers should be inline or the compiler
    will warn that it is unused.

Do you want this to go via the Xen tree or the EFI one?

David
