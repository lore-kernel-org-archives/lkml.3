Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaJPRKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:10:24 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45185 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaJPRKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:10:23 -0400
Date: Thu, 16 Oct 2014 18:10:13 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yifan Zhang <yifan.zhangm@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        "ganapatrao.kulkarni@caviumnetworks.com" 
	<ganapatrao.kulkarni@caviumnetworks.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>,
        "Yalin.Wang@sonymobile.com" <Yalin.Wang@sonymobile.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yifan Zhang <zhangyf@marvell.com>
Subject: Re: [PATCH v2] arm64: mm: use macro instead of if judgement of
 ZONE_DMA
Message-ID: <20141016171012.GE5252@e104818-lin.cambridge.arm.com>
References: <CAGZxSSSBpCvJt=PFbihTmPneJqiocU8VZSDHpXgkf5dhWZ850Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGZxSSSBpCvJt=PFbihTmPneJqiocU8VZSDHpXgkf5dhWZ850Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:41:01AM +0100, Yifan Zhang wrote:
> if disable CONFIG_ZONE_DMA, ZONE_DMA becomes undefined.

I agree that this is the case but can you explain why you need to
disable ZONE_DMA? It currently is def_bool y, so it cannot be disabled
unless you hack the Kconfig.

-- 
Catalin
