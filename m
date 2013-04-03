Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280Ab3DCF7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 01:59:17 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:41669 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab3DCF7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 01:59:15 -0400
Date: Wed, 3 Apr 2013 07:59:09 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: hayeswang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 6/8] r8169: add a new chip for RTL8111G
Message-ID: <20130403055909.GA26022@electric-eye.fr.zoreil.com>
References: <1364824539-4156-1-git-send-email-hayeswang@realtek.com>
 <1364891022-3220-1-git-send-email-hayeswang@realtek.com>
 <1364891022-3220-6-git-send-email-hayeswang@realtek.com>
 <20130402222728.GA16612@electric-eye.fr.zoreil.com>
 <5A289D0C2A6C44158FB4CC5226F8E920@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A289D0C2A6C44158FB4CC5226F8E920@realtek.com.tw>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hayeswang <hayeswang@realtek.com> :
[...]
> Excuse me, I don't sure what is your question. Do you mean if the patch
> "[PATCH v2 net-next 5/8] r8169: Update the RTL8111G parameters" is necessary
> before the current patch? According to the settings from our hw engineers,
> some settings of the new chip are the same with the previous 8111g chip
> using the new parameters. It would work without patch #5. However, it is
> necessary to be updated finally, so I add this patch after patch #5.

I was wondering if some part of #5 would be subject to future changes or
reverted in the context of the new chipset (the global description of the
v2 series did not outline the changes in #5).

It completely answers the question. Sorry for the poor wording.

Thanks.

-- 
Ueimor
