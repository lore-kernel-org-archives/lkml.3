Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaAFDfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 22:35:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49871 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaAFDfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 22:35:48 -0500
Message-ID: <52CA2479.2070006@oracle.com>
Date: Mon, 06 Jan 2014 09:05:21 +0530
From: Allen Pais <allen.pais@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: bigeasy@linutronix.de, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 2/3] sparc64: convert spinlock_t to raw_spinlock_t in
 mmu_context_t
References: <1387166853-10782-3-git-send-email-allen.pais@oracle.com> <52AED5BB.1060002@linutronix.de> <52AEDCFD.9020402@oracle.com> <20140104.203249.1100084640435359350.davem@davemloft.net>
In-Reply-To: <20140104.203249.1100084640435359350.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
>> I did not think it'd be nice to put the call trace in the commit message.
>> But if needed I can re-send them.
> 
> The more information you provide in a commit message, the better.
> 
> Please add those traces to the commit messages, and then you can add
> my:
> 
> Acked-by: David S. Miller <davem@davemloft.net>
Sure. I'll have them re-send now.

 

