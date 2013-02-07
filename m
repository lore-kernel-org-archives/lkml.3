Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab3BGAef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:34:35 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:50337 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab3BGAed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:34:33 -0500
Date: Thu, 7 Feb 2013 01:04:02 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] r8169: fix could not dump registers
Message-ID: <20130207000402.GD2784@electric-eye.fr.zoreil.com>
References: <1360161987-3268-1-git-send-email-hayeswang@realtek.com> <1360161987-3268-5-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360161987-3268-5-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> For new version of Fedora and Ubuntu, we see all 0xff when dumping
> the hw regs through ethtool. Using a loop to read registers could
> fix it.

/me wonders...

Will I be wrong if I reformulate so as to outline the role of 4 bytes
aligned accesses when walking the registers area ?

-- 
Ueimor
