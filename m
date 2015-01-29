Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbbA2N1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:27:37 -0500
Received: from outbound-smtp06.blacknight.com ([81.17.249.39]:54567 "EHLO
	outbound-smtp06.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548AbbA2N1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:27:36 -0500
Message-ID: <54CA3538.3000404@nexus-software.ie>
Date: Thu, 29 Jan 2015 13:27:20 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dvhart@infradead.org, andy.shevchenko@gmail.com,
        boon.leong.ong@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
References: <1422470186-7860-1-git-send-email-pure.logic@nexus-software.ie> <1422470186-7860-2-git-send-email-pure.logic@nexus-software.ie> <20150129074411.GA4817@gmail.com>
In-Reply-To: <20150129074411.GA4817@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/01/15 07:44, Ingo Molnar wrote:

Hi Ingo.

I'll transmit those changes in with the following exception

>> +	ret = imr_write(idev, reg, &imr, false);
>
> So 'ret' here gets mixed with other potential failure modes.
>
> If imr_write() fails here then that's a highly anomalous internal
> failure - so it might be better to add a WARN_ON(ret) or so.
>

imr_write() already does a WARN - so no need to do it again.
