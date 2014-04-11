Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaDKFz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 01:55:58 -0400
Received: from mout.web.de ([212.227.15.3]:61238 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbaDKFz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 01:55:57 -0400
Message-ID: <534783DB.4080200@users.sourceforge.net>
Date: Fri, 11 Apr 2014 07:55:39 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>,
        Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, cocci@systeme.lip6.fr,
        backports@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccinelle: add pycocci wrapper for multithreaded support
References: <1397152097-315-1-git-send-email-mcgrof@do-not-panic.com> <1397152289.4757.28.camel@jlt4.sipsolutions.net> <20140410175748.GK14815@wotan.suse.de>
In-Reply-To: <20140410175748.GK14815@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:lso+koyVgzT7oFNyOX5dotFMxCqQ56nrewFQq9qxwWZAAdbkdO0
 ZQQPe4CR4ZNJLTNGKXW2P2sdICwtyavU/fj+0+uXAAqJTIWW6Z2q2H/QD7/CCQS6iYDyDVA
 WMSbZTKqHE691ut4V1+DYXT1TxNzKxCHpm7eu1imAvbUW20AAvUrFxprJemvZ2Lj2oghkYs
 gvysUMHAF6gWLTxR+NKRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I checked the profile results, the reason the jobs finish is some threads
> had no work or little work.

Could you find out during the data processing which parts or files
result in a special application behaviour you would like to point out here?

Regards,
Markus
