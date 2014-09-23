Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaIWOFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:05:44 -0400
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6608 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaIWOFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:05:41 -0400
X-IronPort-AV: E=McAfee;i="5600,1067,7569"; a="74705482"
X-IronPort-AV: E=Sophos;i="5.04,580,1406617200"; 
   d="scan'208";a="31370382"
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH] ath: change logging functions to return void
Date: Tue, 23 Sep 2014 17:05:34 +0300
Message-ID: <27145768.oo3Xk8YHvr@lx-wigig-72>
User-Agent: KMail/4.13.3 (Linux/3.13.0-35-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1411407334.2952.46.camel@joe-AO725>
References: <1411407334.2952.46.camel@joe-AO725>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: NASANEXM01B.na.qualcomm.com (129.46.53.226) To
 NASANEXM01E.na.qualcomm.com (10.46.201.191)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 22, 2014 10:35:34 AM Joe Perches wrote:
> Other miscellanea:
> 
> o add __printf verification to wil6210 logging functions
>   No format/argument mismatches found
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 

For wil6210:

Acked-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>


