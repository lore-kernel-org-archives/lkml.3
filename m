Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaK0Ltz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:49:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:62780 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbaK0Lty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:49:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,469,1413270000"; 
   d="scan'208";a="629144467"
Date: Thu, 27 Nov 2014 19:29:32 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: mad Engineer <themadengin33r@gmail.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Allocating dedicated RAM to host that guest can not use
Message-ID: <20141127112931.GA3282@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <CAN8oO4BwKdK0AioN=r97NKB=RxrUNrn3822o9nrH466ras+aHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN8oO4BwKdK0AioN=r97NKB=RxrUNrn3822o9nrH466ras+aHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 05:12:52PM +0530, mad Engineer wrote:
>Hi,
>    Is there any way to set some RAM dedicated to host that guest can
>not access?
>Similar to setting RAM to Dom0 in Xen.
>
>I am over committing RAM for the instances but don't want host to swap.
>
>i understand that virtual machines are process,but can we achieve this

How about limit the memory of which guest can access through memory cgroup?

Regards,
Wanpeng Li 

>
>Thanks
>--
>To unsubscribe from this list: send the line "unsubscribe kvm" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
