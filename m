Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaKKRiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:38:21 -0500
Received: from smtp.citrix.com ([66.165.176.89]:15647 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbaKKRiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:38:19 -0500
X-IronPort-AV: E=Sophos;i="5.07,362,1413244800"; 
   d="scan'208";a="190231776"
Message-ID: <5462497A.1080806@citrix.com>
Date: Tue, 11 Nov 2014 17:38:02 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH V3 6/8] xen: Hide get_phys_to_machine() to
 be able to tune common path
References: <1415684626-18590-1-git-send-email-jgross@suse.com> <1415684626-18590-7-git-send-email-jgross@suse.com>
In-Reply-To: <1415684626-18590-7-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/14 05:43, Juergen Gross wrote:
> Today get_phys_to_machine() is always called when the mfn for a pfn
> is to be obtained. Add a wrapper __pfn_to_mfn() as inline function
> to be able to avoid calling get_phys_to_machine() when possible as
> soon as the switch to a linear mapped p2m list has been done.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
