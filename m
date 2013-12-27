Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3L0WBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:01:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56830 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786Ab3L0WBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:01:23 -0500
Message-ID: <52BDF89C.3030207@zytor.com>
Date: Fri, 27 Dec 2013 14:01:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
CC: Michel Lespinasse <walken@google.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>, Gong Chen <gong.chen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86, irq, fix logical AND/OR error in check_irq_vectors_for_cpu_disable()
References: <1387809552-20529-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1387809552-20529-1-git-send-email-prarit@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2013 06:39 AM, Prarit Bhargava wrote:
> Patch is against linux-tip.git and was tested on both linux.git and tip without
> any issues.  As expected, the number of required vectors for the down'd cpu
> drops from 202 to 181 on my test system (which has 509 vectors assigned in
> total).
> 
> Many thanks to Gong Chen for catching this.
> 
> P.
> 
> ----8<----
> 
> Gong Chen caught this coding error during inspection of the patch.  The
> code should be AND not OR.
> 

Please include a description that is understandable by someone who isn't
familiar with the back story to this patch.  The patch descriptions
become part of the permanent record of the history of the Linux kernel
and are critical to it being understandable.

	-hpa

