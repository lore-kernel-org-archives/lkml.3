Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3EaBQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 21:16:43 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:5017 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab3EaBQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 21:16:32 -0400
Message-ID: <51A7F9C7.3080404@huawei.com>
Date: Fri, 31 May 2013 09:15:51 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <guohanjun@huawei.com>
Subject: Re: [PATCH 0/5] scsi: use platform helper macro and wrapper functions
References: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com> <1369924699.1972.4.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1369924699.1972.4.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-05-30 22:38, James Bottomley wrote:
> There doesn't seem to be much point to these patches since either idiom
> is fine and easily understood.  We also try to touch the ancient drivers
> as little as possible since it can be months before anyone actually
> tries them out and notices that something got broken, so the rule for
> them is obvious bug fixes only.
> 
> James

hi James,
Thanks for remind, I got it.



