Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaHYIVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:21:01 -0400
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:50396 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbaHYIU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:20:59 -0400
X-IronPort-AV: E=McAfee;i="5600,1067,7540"; a="72849361"
X-IronPort-AV: E=Sophos;i="5.04,395,1406617200"; 
   d="scan'208";a="791339222"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Hans Wennborg <hans@hanshq.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ath6kl@lists.infradead.org>
Subject: Re: [PATCH 1/1] ath6kl: fix %d confusingly prefixed with 0x in format strings
References: <8738czmejl.fsf@kamboji.qca.qualcomm.com>
	<1408312631-5619-1-git-send-email-hans@hanshq.net>
Date: Mon, 25 Aug 2014 11:20:52 +0300
In-Reply-To: <1408312631-5619-1-git-send-email-hans@hanshq.net> (Hans
	Wennborg's message of "Sun, 17 Aug 2014 14:57:11 -0700")
Message-ID: <87fvgl6kuz.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans Wennborg <hans@hanshq.net> writes:

> Signed-off-by: Hans Wennborg <hans@hanshq.net>

Thanks, applied.

-- 
Kalle Valo
