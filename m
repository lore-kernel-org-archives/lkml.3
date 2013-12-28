Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3L1BHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 20:07:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:52426 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab3L1BHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 20:07:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,563,1384329600"; 
   d="scan'208";a="458608204"
Message-ID: <52BE244B.5040206@linux.intel.com>
Date: Fri, 27 Dec 2013 17:07:23 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        x86@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86, irq, fix logical AND/OR error in check_irq_vectors_for_cpu_disable()
References: <1387809552-20529-1-git-send-email-prarit@redhat.com> <20131224025059.GA24419@gchen.bj.intel.com> <52B989CD.6060403@redhat.com> <20131225024048.GA29542@gchen.bj.intel.com> <52BDA70C.1080508@redhat.com>
In-Reply-To: <52BDA70C.1080508@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2013 08:13 AM, Prarit Bhargava wrote:
>>
>> Back to my question, assume cpu1 will be off-lined and one irq affinity is
>> set as (1, 2) -- this irq will be bypassed. Looks good. But if one irq
>> affinity is set as only (1), -- this irq is bypassed, too. Not right!
> 
> Oh, yes, this is a bug.  ... and as you point out ...
> 

Does this mean the patch that is currently in my tree should not be
pushed to Linus?  It sounds like that to me...

	-hpa

