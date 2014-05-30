Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554AbaE3MnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:43:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34140 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932413AbaE3MnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:43:21 -0400
Date: Fri, 30 May 2014 13:43:19 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Mark Brown <broonie@kernel.org>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH] extcon: Set parent device of extcon device using
	prameter of devm_extcon_dev_allocate
Message-ID: <20140530124319.GC11951@opensource.wolfsonmicro.com>
References: <1401414099-10937-1-git-send-email-cw00.choi@samsung.com> <20140530093638.GA11951@opensource.wolfsonmicro.com> <5388540F.7070507@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5388540F.7070507@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 06:49:03PM +0900, Chanwoo Choi wrote:
> Hi Charles,
> 
> OK, Let me know about test result.
> 
> Thanks,
> Chanwoo Choi

Yeah that seems to work fine here. For the Arizona bit you can
add:

Tested-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
