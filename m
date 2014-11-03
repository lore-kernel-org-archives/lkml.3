Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaKCWzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:55:54 -0500
Received: from numascale.com ([213.162.240.84]:57828 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbaKCWzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:55:51 -0500
Message-ID: <545807ED.5090804@numascale.com>
Date: Tue, 04 Nov 2014 06:55:41 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH v3 3/5] Numachip: Add safe is-present function
References: <1414915813-2462-1-git-send-email-daniel@numascale.com> <1414915813-2462-3-git-send-email-daniel@numascale.com> <alpine.DEB.2.11.1411032044590.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1411032044590.5308@nanos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 03:45 AM, Thomas Gleixner wrote:
> On Sun, 2 Nov 2014, Daniel J Blueman wrote:
>
>> Add safe function to check if Numachip is detected, to be used elsewhere.
>
> I cannot find a use case for this. I guess this is a left over of the
> earlier 2G change, right?

I left it in as it's common to apic_numachip.c and a Numachip2 patch 
series I'll present later.

Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
