Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab3KFPKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:10:20 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:40693 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab3KFPKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:10:18 -0500
Message-ID: <527A5BD4.3000405@gmail.com>
Date: Wed, 06 Nov 2013 23:10:12 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Will Deacon <Will.Deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/7] arm64: introduce basic aarch64 instruction decoding
 helpers
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com> <1382109602-27432-2-git-send-email-liuj97@gmail.com> <20131031173946.GL26009@arm.com>
In-Reply-To: <20131031173946.GL26009@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 01:39 AM, Catalin Marinas wrote:
> On Fri, Oct 18, 2013 at 04:19:55PM +0100, Jiang Liu wrote:
>> +/*
>> + * ARMv8-A Section B2.6.5:
> 
> Minor comment - please specify the document revision and the title of
> the section as they keep changing in subsequent ARMv8 ARM updates and
> this comment would no longer match.
> 
Thanks for review, will improve it in next version.
