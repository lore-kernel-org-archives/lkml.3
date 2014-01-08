Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbaAHLJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:09:08 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46140 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755737AbaAHLJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:09:06 -0500
Date: Wed, 8 Jan 2014 11:08:32 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 6/7] arm64, jump label: optimize jump label
 implementation
Message-ID: <20140108110831.GA20644@mudshark.cambridge.arm.com>
References: <1389104234-15239-1-git-send-email-liuj97@gmail.com>
 <1389104234-15239-7-git-send-email-liuj97@gmail.com>
 <20140107154622.GA4399@mudshark.cambridge.arm.com>
 <52CD3132.4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CD3132.4@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 11:06:26AM +0000, Jiang Liu wrote:
> Hi Will,
> 	Who should I send this patch set for merging?

Catalin and I will pick up it from here and take it via the arm64 tree, so
you don't need to do anything.

Cheers,

Will
