Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbbAMOUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:20:50 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59302 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbbAMOUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:20:48 -0500
X-IronPort-AV: E=McAfee;i="5600,1067,7679"; a="97968961"
Cc: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>,
        Michal Kazior <michal.kazior@tieto.com>,
        Yanbo Li <yanbol@qca.qualcomm.com>,
        Ben Greear <greearb@candelatech.com>
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="31472865"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH v3] ath10k: fixup wait_for_completion_timeout return handling
References: <1420720054-27870-1-git-send-email-der.herr@hofr.at>
Date: Tue, 13 Jan 2015 16:20:27 +0200
In-Reply-To: <1420720054-27870-1-git-send-email-der.herr@hofr.at> (Nicholas Mc
	Guire's message of "Thu, 8 Jan 2015 13:27:34 +0100")
Message-ID: <87d26i69uc.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: NASANEXM01F.na.qualcomm.com (10.85.0.32) To
 NALASEXR01G.na.qualcomm.com (10.49.56.53)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Mc Guire <der.herr@hofr.at> writes:

> wait_for_completion_timeout does not return negative values so the tests
> for <= 0 are not needed and the case differentiation in the error handling
> path unnecessary.
>
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

Thanks, applied to ath.git.

-- 
Kalle Valo
