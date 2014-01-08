Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaAHIXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:23:35 -0500
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:36807 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbaAHIXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:23:25 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,7311"; a="57389999"
X-IronPort-AV: E=McAfee;i="5400,1158,7311"; a="24973209"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Alexander Gordeev <agordeev@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <ath10k@lists.infradead.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 6/7] ath10k: Use new interfaces for MSI enablement
References: <cover.1389103215.git.agordeev@redhat.com>
	<dc640013c28e6e24b4f7293a8adbd2b60a8f48c4.1389103215.git.agordeev@redhat.com>
Date: Wed, 8 Jan 2014 10:23:18 +0200
In-Reply-To: <dc640013c28e6e24b4f7293a8adbd2b60a8f48c4.1389103215.git.agordeev@redhat.com>
	(Alexander Gordeev's message of "Tue, 7 Jan 2014 19:05:41 +0100")
Message-ID: <87txdehog9.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Gordeev <agordeev@redhat.com> writes:

> This update also fixes a stylistic (naming and messaging only)
> confusion of MSI-X vs multiple MSIs which are not the same.
>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Looks good to me.

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

Do you want me to take this patch to my ath.git tree or how were you
planning to handle it?

-- 
Kalle Valo
