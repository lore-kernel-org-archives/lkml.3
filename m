Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbaAHPmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:42:07 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:22889 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755388AbaAHPmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:42:06 -0500
Date: Wed, 8 Jan 2014 15:41:36 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Jiang Liu <liuj97@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 6/7] arm64, jump label: optimize jump label
 implementation
Message-ID: <20140108154136.GD15212@arm.com>
References: <1389104234-15239-1-git-send-email-liuj97@gmail.com>
 <1389104234-15239-7-git-send-email-liuj97@gmail.com>
 <20140107154622.GA4399@mudshark.cambridge.arm.com>
 <52CD3132.4@gmail.com>
 <20140108110831.GA20644@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108110831.GA20644@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 11:08:32AM +0000, Will Deacon wrote:
> On Wed, Jan 08, 2014 at 11:06:26AM +0000, Jiang Liu wrote:
> > 	Who should I send this patch set for merging?
> 
> Catalin and I will pick up it from here and take it via the arm64 tree, so
> you don't need to do anything.

Done. It should appear in linux-next overnight (Jiang, please check in
case I missed anything).

Thanks.

-- 
Catalin
