Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaG3A5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 20:57:51 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:16796 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaG3A5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 20:57:50 -0400
From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huangweidong (C)" <weidong.huang@huawei.com>
Subject: RE: [Question] suse11sp3 32bit guest os panic on kvm 
Thread-Topic: [Question] suse11sp3 32bit guest os panic on kvm 
Thread-Index: AQHPqzRqUs5BN50+VES4D0Z3Gyk7YZu3y3PA
Date: Wed, 30 Jul 2014 00:57:36 +0000
Message-ID: <33183CC9F5247A488A2544077AF1902086C1DA05@SZXEMA503-MBS.china.huawei.com>
References: <33183CC9F5247A488A2544077AF1902086C180A4@SZXEMA503-MBS.china.huawei.com>
 <alpine.LRH.2.00.1407291551260.31288@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.1407291551260.31288@twin.jikos.cz>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.19.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jiri Kosina [mailto:jkosina@suse.cz]
> Sent: Tuesday, July 29, 2014 9:53 PM
> To: Gonglei (Arei)
> Cc: linux-kernel@vger.kernel.org; Huangweidong (C)
> Subject: Re: [Question] suse11sp3 32bit guest os panic on kvm
> 
> On Wed, 2 Jul 2014, Gonglei (Arei) wrote:
> 
> > Recently I encounter a confused issue that described by the title.
> > I get the dump core according "virsh dump", and this below is the core
> > Information. It seem as that the vcpu deadlock between irqbalance
> > process(_raw_spin_lock_irqsave) and an interrupt handle
> > (_raw_spin_lock), I'm so confused.
> >
> > Any suggestions will be appreciated!
> 
> This is a distribution vendor provided kernel, you should use the proper
> support channels you have established with the vendor. General kernel
> community is very unlikely to help you here.
> 
> --
> Jiri Kosina
> SUSE Labs

Ok, I have found the root reason of this issue.
Thank you all the same.

Best regards,
-Gonglei
