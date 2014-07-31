Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaGaSJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 14:09:40 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:47779 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbaGaSJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 14:09:39 -0400
X-IronPort-AV: E=Sophos;i="5.01,773,1400025600"; 
   d="scan'208";a="158193990"
Message-ID: <53DA8661.5050107@citrix.com>
Date: Thu, 31 Jul 2014 19:09:37 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: <weiyj_lk@163.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/pciback: Fix error return code in xen_pcibk_attach()
References: <1405835161-8546-1-git-send-email-weiyj_lk@163.com>
In-Reply-To: <1405835161-8546-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/07/14 06:46, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -EFAULT from the error handling case instead of 0 when
> version mismatch with pcifront.

Applied to devel/for-linus-3.16

Although the return value of this function is never used.

David
