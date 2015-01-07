Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbbAGREr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:04:47 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20153 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbbAGREp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:04:45 -0500
X-IronPort-AV: E=McAfee;i="5600,1067,7673"; a="96994917"
Cc: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>,
        Michal Kazior <michal.kazior@tieto.com>,
        Yanbo Li <yanbol@qca.qualcomm.com>,
        Ben Greear <greearb@candelatech.com>
X-IronPort-AV: E=Sophos;i="5.07,715,1413270000"; 
   d="scan'208";a="25657832"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH v2] ath10k: fixup wait_for_completion_timeout return handling
References: <1419968660-17404-1-git-send-email-der.herr@hofr.at>
Date: Wed, 7 Jan 2015 19:04:36 +0200
In-Reply-To: <1419968660-17404-1-git-send-email-der.herr@hofr.at> (Nicholas Mc
	Guire's message of "Tue, 30 Dec 2014 14:44:20 -0500")
Message-ID: <87sifmsesb.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: NASANEXM01B.na.qualcomm.com (10.85.0.82) To
 NALASEXR01G.na.qualcomm.com (10.49.56.53)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Mc Guire <der.herr@hofr.at> writes:

> wait_for_completion_timeout does not return negative values so the tests
> for <= 0 are not needed and the case differentiation in the error handling
> path unnecessary.
>
> v2: all wait_for_completion_timeout changes in a single patch
>
> patch was only compile tested x86_64_defconfig + CONFIG_ATH_CARDS=m
> CONFIG_ATH10K=m
>
> patch is against linux-next 3.19.0-rc1 -next-20141226
>
> None of the proposed cleanups are critical.
> All changes should only be removing unreachable cases.
>
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---

All the comments after "v2:" should be here, under the "---" line so
that git-am can automatically discard them.

-- 
Kalle Valo
