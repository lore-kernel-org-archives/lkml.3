Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaIVPtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:49:07 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54515 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIVPtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:49:05 -0400
Date: Mon, 22 Sep 2014 08:48:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Josh Cartwright <joshc@codeaurora.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2] power: reset: use restart_notifier mechanism for
 msm-poweroff
Message-ID: <20140922154859.GC5054@roeck-us.net>
References: <1411371774-6834-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411371774-6834-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 01:12:54PM +0530, Pramod Gurav wrote:
> This change replaces use of arm_pm_restart with recently introduced
> reset mechanism in Linux kernel called restart_notifier.
> 
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Josh Cartwright <joshc@codeaurora.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: linux-pm@vger.kernel.org
> 
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
