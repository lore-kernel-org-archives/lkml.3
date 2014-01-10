Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaAJRj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:39:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:54474 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaAJRj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:39:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,639,1384329600"; 
   d="scan'208";a="456803714"
Message-ID: <52D0305D.2000801@intel.com>
Date: Fri, 10 Jan 2014 09:39:41 -0800
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net V3 1/2] macvlan: forbid L2 fowarding offload for macvtap
References: <1389341906-2367-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1389341906-2367-1-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/2014 12:18 AM, Jason Wang wrote:
> L2 fowarding offload will bypass the rx handler of real device. This will make
> the packet could not be forwarded to macvtap device. Another problem is the
> dev_hard_start_xmit() called for macvtap does not have any synchronization.
>
> Fix this by forbidding L2 forwarding for macvtap.
>
> Cc: John Fastabend <john.r.fastabend@intel.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---

Same thing here tested my l2 forwarding offload use cases
and they still work. Thanks! For net-next we can look at
getting macvtap to work correctly.

Acked-by: John Fastabend <john.r.fastabend@intel.com.com>

