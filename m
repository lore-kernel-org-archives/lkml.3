Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab3BLWEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:04:44 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61651 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab3BLWEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:04:41 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@vger.kernel.org, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/16] ARM idle: delete pm_idle
References: <1360475903-30007-1-git-send-email-lenb@kernel.org>
	<2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
	<9838a4aeee256adeaef90efe56df2c9988206982.1360475150.git.len.brown@intel.com>
Date: Tue, 12 Feb 2013 14:04:37 -0800
In-Reply-To: <9838a4aeee256adeaef90efe56df2c9988206982.1360475150.git.len.brown@intel.com>
	(Len Brown's message of "Sun, 10 Feb 2013 00:58:13 -0500")
Message-ID: <87pq05i3yi.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

> From: Len Brown <len.brown@intel.com>
>
> pm_idle() on ARM was a synonym for default_idle(),
> so simply invoke default_idle() directly.
>
> Signed-off-by: Len Brown <len.brown@intel.com>
> Cc: linux-arm-kernel@lists.infradead.org

Looks good to me.

Tested this patch along with 15/16 (removes global declaration) on an
ARM platform (TI OMAP3) with and without CPUidle, and things continue to
work as expected:

Reviewed-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Kevin Hilman <khilman@linaro.org>

Kevin
