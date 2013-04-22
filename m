Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3DVVoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:44:03 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:37196 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781Ab3DVVoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:44:00 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz17326ah8275dhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1155h)
X-WSS-ID: 0MLOF16-02-1Y7-02
X-M-MSG: 
Message-ID: <5175AF1B.2010409@amd.com>
Date: Mon, 22 Apr 2013 16:43:55 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 V2] iommu/amd: Add workaround for ERBT1312
References: <1366009666-44792-1-git-send-email-suravee.suthikulpanit@amd.com> <20130418160220.GA4153@8bytes.org> <51701B9F.10003@amd.com> <20130418162856.GA13891@8bytes.org> <5170268E.8080706@amd.com> <20130418183538.GA17148@8bytes.org> <517041EA.70407@amd.com> <20130418200613.GB17148@8bytes.org>
In-Reply-To: <20130418200613.GB17148@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/18/2013 3:06 PM, Joerg Roedel wrote:
> Yes, but the irq-thread function itself executes the handler function
> repeatedly until the IRQTF_RUNTHREAD bit is cleared. And every new
> interrupt will set this bit again. So when there is a new interrupt
> while our handler function runs the handler will be called again by the
> irq-thread.
>
>
> 	Joerg
Thank you for the clarification.  I have submitted a new patch based on 
the new workaround code. 
(http://lists.linuxfoundation.org/pipermail/iommu/2013-April/005574.html)

Suravee

