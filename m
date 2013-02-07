Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab3BGAdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:33:43 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:50330 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab3BGAdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:33:39 -0500
Date: Thu, 7 Feb 2013 01:03:07 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] r8169: Update the RTL8111G parameters
Message-ID: <20130207000307.GC2784@electric-eye.fr.zoreil.com>
References: <1360161987-3268-1-git-send-email-hayeswang@realtek.com> <1360161987-3268-4-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360161987-3268-4-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> - replace rtl8168g-1.fw with rtl8168g-2.fw which support new method.
> - fix PHY power down is useless.
> - disable rx early which causes the rx abnormal.
> - fix the conflict between jumbo frame and flow control.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

It seems ok.

-- 
Ueimor
