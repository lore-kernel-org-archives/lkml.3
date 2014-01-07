Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaAGNlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:41:52 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:38703 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaAGNlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:41:46 -0500
X-IronPort-AV: E=Sophos;i="4.95,618,1384300800"; 
   d="scan'208";a="88271678"
Message-ID: <52CC0418.7090405@citrix.com>
Date: Tue, 7 Jan 2014 13:41:44 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <yongjun_wei@trendmicro.com.cn>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] xen/evtchn_fifo: fix error return code in evtchn_fifo_setup()
References: <CAPgLHd_AO6mEwaemSobCMwCg2J=xmH+-FF0Ek+PS8ZYdHJStXw@mail.gmail.com>
In-Reply-To: <CAPgLHd_AO6mEwaemSobCMwCg2J=xmH+-FF0Ek+PS8ZYdHJStXw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/14 13:11, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -ENOMEM from the error handling case instead of
> 0 (overwrited to 0 by the HYPERVISOR_event_channel_op call),
> otherwise the error condition cann't be reflected from the
> return value.

Thanks.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
