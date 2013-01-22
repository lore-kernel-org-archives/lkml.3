Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3AVShA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:37:00 -0500
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:10441 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab3AVSg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:36:56 -0500
X-IronPort-AV: E=Sophos;i="4.84,515,1355126400"; 
   d="scan'208";a="17437626"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Kees Cook <keescook@chromium.org>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 12/20] drivers/net/wireless/ath/ath6kl: remove depends on CONFIG_EXPERIMENTAL
References: <1358879444-25834-1-git-send-email-keescook@chromium.org>
	<1358879444-25834-13-git-send-email-keescook@chromium.org>
Date: Tue, 22 Jan 2013 20:36:48 +0200
In-Reply-To: <1358879444-25834-13-git-send-email-keescook@chromium.org> (Kees
	Cook's message of "Tue, 22 Jan 2013 10:30:36 -0800")
Message-ID: <87r4ldcben.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

Do you want me to apply this to ath6kl.git (the normal route for ath6kl
patches) or what's the plan?

-- 
Kalle Valo
