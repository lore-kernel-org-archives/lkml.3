Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaIYNTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:19:30 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:39461 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaIYNT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:19:28 -0400
MIME-Version: 1.0
In-Reply-To: <1411575342-31048-3-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
	<1411575342-31048-3-git-send-email-vinod.koul@intel.com>
Date: Thu, 25 Sep 2014 15:19:28 +0200
Message-ID: <CACRpkdZCzWyNVTL4+hDqvvE50hP71jyg7=+cH70tnCDF6_Q8Qw@mail.gmail.com>
Subject: Re: [PATCH 02/27] dmaengine: ste_dma: use pm_runtime_last_busy_and_autosuspend
 helper
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        subhransu.s.prusty@intel.com, Dan Williams <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dmaengine@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 6:14 PM, Vinod Koul <vinod.koul@intel.com> wrote:

> Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> coding the same code
>
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
