Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277Ab3DAWYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:24:39 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:37014 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759011Ab3DAWYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:24:38 -0400
Date: Tue, 2 Apr 2013 00:24:32 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 7/7] r8169: fix could not dump registers
Message-ID: <20130401222432.GD19335@electric-eye.fr.zoreil.com>
References: <1364824539-4156-1-git-send-email-hayeswang@realtek.com>
 <1364824539-4156-7-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364824539-4156-7-git-send-email-hayeswang@realtek.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> For new version of Fedora and Ubuntu, we see all 0xff when dumping
> the hw regs through ethtool. Using a loop to read registers could
> fix it.

If it fixes a problem which lives outside of net-next, it should target
"net", not "net-next".

"new version" does not help when a commit log can be read at any time
and/or when people try to identify patches for -stable branches. You do
not say which kernel / chipsets combination are known to exhibit the
problem.

Fundamentally, nobody can tell from the description if it is a kernel
or hardware problem nor why things work better after the change.

-- 
Ueimor
