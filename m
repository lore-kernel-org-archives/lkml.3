Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaLALcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:32:25 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:21979 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaLALcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:32:24 -0500
X-IronPort-AV: E=Sophos;i="5.07,493,1413244800"; 
   d="scan'208";a="198352434"
Message-ID: <547C51AD.8070904@citrix.com>
Date: Mon, 1 Dec 2014 11:31:57 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <hpa@zytor.com>, <andrew.cooper3@citrix.com>
Subject: Re: [PATCH V4 00/10] xen: Switch to virtual mapped linear p2m list
References: <1417172039-8627-1-git-send-email-jgross@suse.com>
In-Reply-To: <1417172039-8627-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
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

What are the results of the testing I asked for?

If Konrad or Boris are happy with this series I think it can go into 3.19.

David
