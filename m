Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3CJN12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:27:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22088 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab3CJN10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:27:26 -0400
X-IronPort-AV: E=Sophos;i="4.84,817,1355126400"; 
   d="scan'208";a="28475796"
X-IronPort-AV: E=Sophos;i="4.84,817,1355126400"; 
   d="scan'208";a="415145975"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Andrei Epure <epure.andrei@gmail.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath: changed kmalloc to kmemdup
References: <1362919199-16292-1-git-send-email-epure.andrei@gmail.com>
Date: Sun, 10 Mar 2013 15:27:20 +0200
In-Reply-To: <1362919199-16292-1-git-send-email-epure.andrei@gmail.com>
	(Andrei Epure's message of "Sun, 10 Mar 2013 14:39:58 +0200")
Message-ID: <87ehfnfkqv.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrei Epure <epure.andrei@gmail.com> writes:

> Signed-off-by: Andrei Epure <epure.andrei@gmail.com>

Thanks, I'll take this. But please prefix ath6kl patches with "ath6kl:"
in the future.

-- 
Kalle Valo
