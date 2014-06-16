Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaFPMAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 08:00:36 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:43253 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaFPMAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 08:00:34 -0400
X-IronPort-AV: E=Sophos;i="5.01,486,1400025600"; 
   d="scan'208";a="143700221"
Message-ID: <539EDC5D.4010207@citrix.com>
Date: Mon, 16 Jun 2014 13:00:29 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>
CC: <andrew.cooper3@citrix.com>, <boris.ostrovsky@oracle.com>,
        <eshelton@pobox.com>, <hpa@zytor.com>, <ian.campbell@citrix.com>,
        <jbeulich@suse.com>, <jeremy@goop.org>, <konrad.wilk@oracle.com>,
        <matt.fleming@intel.com>, <mingo@redhat.com>, <mjg59@srcf.ucam.org>,
        <stefano.stabellini@eu.citrix.com>, <tglx@linutronix.de>
Subject: Re: [PATCH v5 4/7] xen: Put EFI machinery in place
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com> <1402678823-24589-5-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1402678823-24589-5-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/14 18:00, Daniel Kiper wrote:
> 
> v5 - suggestions/fixes:

Put after a --- marker.

> +static efi_char16_t vendor[100] __initdata;

Why 100?

David
