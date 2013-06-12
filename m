Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab3FLNES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:04:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab3FLNER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:04:17 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=ofFxtc/jepklO3aWSWiKGA==:17 a=99CFIlhQ8dUA:10 a=XqBCkJwx3yUA:10 a=ujDnKloYHBoA:10 a=vQlp3vXYDpMA:10 a=8nJEP1OIZ-IA:10 a=2KX_Yc5PAAAA:8 a=b2FVD6rLsxQA:10 a=Lho3XWU90ZvA3quhAIMA:9 a=wPNLvfGTeEIA:10 a=ofFxtc/jepklO3aWSWiKGA==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.112.99.80
Message-ID: <51B871CB.1090808@tabi.org>
Date: Wed, 12 Jun 2013 08:04:11 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:20.0) Gecko/20100101 Firefox/20.0 SeaMonkey/2.17.1
MIME-Version: 1.0
To: Oded Gabbay <ogabbay@advaoptical.com>, benh@kernel.crashing.org,
        paulus@samba.org, leoli@freescale.com, galak@kernel.crashing.org,
        B38951@freescale.com, Dongsheng.Wang@freescale.com,
        bigeasy@linutronix.de, stef.van.os@prodrive.nl, davem@davemloft.net
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] MDIO: FSL_PQ_MDIO: Fix bug on incorrect offset of tbipa
 register
References: <1371041258-15298-1-git-send-email-ogabbay@advaoptical.com>
In-Reply-To: <1371041258-15298-1-git-send-email-ogabbay@advaoptical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oded Gabbay wrote:
> Note: This patch may break MDIO functionallity of some old Freescale's SoC
> until Freescale will fix their device tree files. Basically, every device tree
> which contains an mdio device that is compatible to "fsl,gianfar-tbi" should be
> examined.

I haven't had a chance to review the patch in detail, but I can tell you 
that breaking compatibility with older device trees is unacceptable.  You 
need to add some code, even if it's an ugly hack, to support those trees.

-- 
Timur Tabi
