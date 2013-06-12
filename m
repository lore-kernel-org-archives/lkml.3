Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab3FLNKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:10:17 -0400
Received: from mail.advaoptical.com ([91.217.199.15]:56223 "EHLO
	mail.advaoptical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3FLNKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:10:16 -0400
X-Greylist: delayed 1281 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jun 2013 09:10:15 EDT
Message-ID: <51B8730F.2030606@advaoptical.com>
Date: Wed, 12 Jun 2013 16:09:35 +0300
From: Oded Gabbay <ogabbay@advaoptical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Timur Tabi <timur@tabi.org>
CC: <benh@kernel.crashing.org>, <paulus@samba.org>, <leoli@freescale.com>,
        <galak@kernel.crashing.org>, <B38951@freescale.com>,
        <Dongsheng.Wang@freescale.com>, <bigeasy@linutronix.de>,
        <stef.van.os@prodrive.nl>, <davem@davemloft.net>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] MDIO: FSL_PQ_MDIO: Fix bug on incorrect offset of tbipa
 register
References: <1371041258-15298-1-git-send-email-ogabbay@advaoptical.com> <51B871CB.1090808@tabi.org>
In-Reply-To: <51B871CB.1090808@tabi.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.179.55]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-12_03:2013-06-12,2013-06-12,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oded Gabbay wrote:
>> Note: This patch may break MDIO functionallity of some old 
>> Freescale's SoC
>> until Freescale will fix their device tree files. Basically, every 
>> device tree
>> which contains an mdio device that is compatible to "fsl,gianfar-tbi" 
>> should be
>> examined.
>
> On 06/12/2013 04:04 PM, Timur Tabi wrote:
> I haven't had a chance to review the patch in detail, but I can tell 
> you that breaking compatibility with older device trees is 
> unacceptable.  You need to add some code, even if it's an ugly hack, 
> to support those trees.
>
I generally agree with this statement except that without this patch, 
almost ALL of Freescale's SoC that uses "fsl,gianfar-tbi" are broken, 
including the older ones. At least this patch fixes some of the device 
trees. Because I'm not working at Freescale, I have a very limited 
access to a few SoC which I could test this patch on. I think it is 
Freescale's responsibility to release a complementary patch to fix the 
rest of the SoC device trees.

Oded
