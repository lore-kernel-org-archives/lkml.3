Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaG2Nwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:52:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbaG2Nww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:52:52 -0400
Date: Tue, 29 Jul 2014 15:52:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Gonglei (Arei)" <arei.gonglei@huawei.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huangweidong (C)" <weidong.huang@huawei.com>
Subject: Re: [Question] suse11sp3 32bit guest os panic on kvm 
In-Reply-To: <33183CC9F5247A488A2544077AF1902086C180A4@SZXEMA503-MBS.china.huawei.com>
Message-ID: <alpine.LRH.2.00.1407291551260.31288@twin.jikos.cz>
References: <33183CC9F5247A488A2544077AF1902086C180A4@SZXEMA503-MBS.china.huawei.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014, Gonglei (Arei) wrote:

> Recently I encounter a confused issue that described by the title.
> I get the dump core according "virsh dump", and this below is the core
> Information. It seem as that the vcpu deadlock between irqbalance
> process(_raw_spin_lock_irqsave) and an interrupt handle
> (_raw_spin_lock), I'm so confused. 
> 
> Any suggestions will be appreciated!

This is a distribution vendor provided kernel, you should use the proper 
support channels you have established with the vendor. General kernel 
community is very unlikely to help you here.

-- 
Jiri Kosina
SUSE Labs

