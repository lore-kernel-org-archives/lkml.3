Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3EUJ07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:26:59 -0400
Received: from intranet.asianux.com ([58.214.24.6]:40238 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3EUJ06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:26:58 -0400
X-Spam-Score: -100.8
Message-ID: <519B3DB0.4020806@asianux.com>
Date: Tue, 21 May 2013 17:26:08 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: kernel: compiling issue, need 'EXPORT_SYMBOL_GPL(read_current_timer)'
References: <5199C725.8050102@asianux.com> <168084c28e8ba5124c05553e97463172@localhost> <20130520095606.GH31359@mudshark.cambridge.arm.com> <519AF2DC.2040200@asianux.com> <5bf8a8dd20ecd01c14f0ed9aa054f2df@localhost> <519B332F.1000404@asianux.com> <519B3738.1010004@arm.com>
In-Reply-To: <519B3738.1010004@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 04:58 PM, Marc Zyngier wrote:
> I think you should try to implement Will's suggestion and drop
> read_current_timer (and the ARCH_HAS_READ_CURRENT_TIMER macro) altogether.
> 
> It would be a much better fix.

OK, thanks. I will send patch v2.

-- 
Chen Gang

Asianux Corporation
