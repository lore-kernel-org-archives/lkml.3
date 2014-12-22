Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbaLVQKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:10:13 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:43915 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbaLVQKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:10:11 -0500
X-IronPort-AV: E=Sophos;i="5.07,624,1413244800"; 
   d="scan'208";a="207546450"
Message-ID: <54984255.8030702@citrix.com>
Date: Mon, 22 Dec 2014 16:09:57 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel <xen-devel@lists.xenproject.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] Testing preemptibility test in xen_setup_cpu_clockevents()
References: <54983E8F.5060500@oracle.com>
In-Reply-To: <54983E8F.5060500@oracle.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/12/14 15:53, Boris Ostrovsky wrote:
> With 250a1ac685f (x86, smpboot: Remove pointless preempt_disable() in
> native_smp_prepare_cpus()) HVM guests no longer boot since we are
> hitting BUG_ON(preemptible()) in xen_setup_cpu_clockevents().
> 
> I don't think we need this test (PV or HVM), do we?

It looks safe to remove the BUG_ON().

David
