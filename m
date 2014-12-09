Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbaLIXtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 18:49:11 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:44636 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaLIXtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 18:49:03 -0500
Date: Wed, 10 Dec 2014 00:48:58 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Chunhao Lin <hau@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/9] r8169:update rtl8168fb ephy parameter
Message-ID: <20141209234858.GB22285@electric-eye.fr.zoreil.com>
References: <1418143563-7652-1-git-send-email-hau@realtek.com>
 <1418143563-7652-6-git-send-email-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418143563-7652-6-git-send-email-hau@realtek.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chunhao Lin <hau@realtek.com> :
[rtl_hw_start_8168f_1 and rtl_hw_start_8168f_2 changes]

Different ephy_info data, same code. You may consider factoring it out.

-- 
Ueimor
