Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbaLDPpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:45:22 -0500
Received: from smtp.citrix.com ([66.165.176.89]:14409 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932407AbaLDPpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:45:20 -0500
X-IronPort-AV: E=Sophos;i="5.07,516,1413244800"; 
   d="scan'208";a="199780131"
Message-ID: <54808175.8040801@citrix.com>
Date: Thu, 4 Dec 2014 15:44:53 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <andrew.cooper3@citrix.com>
Subject: Re: [Xen-devel] [PATCH V4 00/10] xen: Switch to virtual mapped linear
 p2m list
References: <1417172039-8627-1-git-send-email-jgross@suse.com>
In-Reply-To: <1417172039-8627-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/11/14 10:53, Juergen Gross wrote:
> Paravirtualized kernels running on Xen use a three level tree for
> translation of guest specific physical addresses to machine global
> addresses. This p2m tree is used for construction of page table
> entries, so the p2m tree walk is performance critical.
> 
> By using a linear virtual mapped p2m list accesses to p2m elements
> can be sped up while even simplifying code. To achieve this goal
> some p2m related initializations have to be performed later in the
> boot process, as the final p2m list can be set up only after basic
> memory management functions are available.

Applied to devel/for-linus-3.19.

Thanks.

David
