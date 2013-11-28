Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab3K1GjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 01:39:01 -0500
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:50542 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706Ab3K1GjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 01:39:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkDAHrkllJ8q8ai/2dsb2JhbAANTIcMskSCfwMCgTWDGQEBAQR4ARALGAQFFg0CCQMCAQIBRQYBDAEHAQGHagGTTJprbgaQaBeBI41kB4JlgU4Dol+LAw
X-IronPort-AV: E=Sophos;i="4.93,789,1378828800"; 
   d="scan'208";a="137563962"
X-WN-REMOTEIP: 124.171.198.162
X-WN-ENVELOPESENDER: gregungerer@westnet.com.au
X-WN-MID: 137563962
X-WN-SMTPAUTHID: gregungerer@westnet.com.au
Message-ID: <5296E4FF.4030906@westnet.com.au>
Date: Thu, 28 Nov 2013 16:38:55 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: eunb.song@samsung.com, "geert@linux-m68k.org" <geert@linux-m68k.org>
CC: "linux-m68k@lists.linux-m68k.org" <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k : Kill CONFIG_MTD_PARTITIONS
References: <28966598.284941385600648144.JavaMail.weblogic@epv6ml06>
In-Reply-To: <28966598.284941385600648144.JavaMail.weblogic@epv6ml06>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi EunBong,

On 28/11/13 11:04, Eunbong Song wrote:
>> Hi Eunbong,
> 
>> Acked-by: Greg Ungerer
> 
>> Did you want me to pick this up for the m68knommu git tree?
> Hello, Greg.
> I'm glad if  you pick up this patch.

Ok, done. Added it to the for-next branch of the m68knommu git
tree. Thanks.

Regards
Greg



