Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaIZIik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:38:40 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:63014 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaIZIii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:38:38 -0400
MIME-Version: 1.0
In-Reply-To: <1411575342-31048-12-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
	<1411575342-31048-12-git-send-email-vinod.koul@intel.com>
Date: Fri, 26 Sep 2014 10:38:38 +0200
Message-ID: <CACRpkdZdEJndkE5mpkoUMN-do=LU8fMpkyjJb0RQnOjJYGRQqg@mail.gmail.com>
Subject: Re: [PATCH 11/27] mfd: ab8500-gpadc: use pm_runtime_last_busy_and_autosuspend
 helper
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        subhransu.s.prusty@intel.com, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 6:15 PM, Vinod Koul <vinod.koul@intel.com> wrote:

> Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> coding the same code
>
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
