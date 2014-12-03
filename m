Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaLCNA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:00:56 -0500
Received: from mout.web.de ([212.227.15.4]:58093 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbaLCNAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:00:54 -0500
Message-ID: <547F0977.7090908@users.sourceforge.net>
Date: Wed, 03 Dec 2014 14:00:39 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Julia Lawall <julia.lawall@lip6.fr>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Coccinelle <cocci@systeme.lip6.fr>, backports@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [patch] CodingStyle: add some more error handling guidelines
References: <20141202085950.GA13434@mwanda> <547F0297.6030202@users.sourceforge.net> <20141203124511.GR5048@mwanda>
In-Reply-To: <20141203124511.GR5048@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:QIsSIcCOoePhlhdUucuClEUYDuQVAvWTpfjeV0blJLGQOU93GTz
 W/xyMc3rjcsN5uTTHz3pE+d01lKV3T7s5Mxqn5e556tpctdfxttdlIAGoSj9a+PfZTxJowT
 oLkUQB5wLSZo5iGUfOhsxuGHg7crxulhX+rAZziyKdgMD+eYfKy5LApAiguTvNLyiD4yejr
 nkRjc+Y4otPo2KKvLnSKg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> * To which source code place should the word "location" refer to?
>>   - jump source
>>   - jump target
> 
> jump target.

Thanks for the clarification of your intention.

I wonder then why I got the feedback "That is a useless thing to do."
from you yesterday.
I hope that we can still clarify our different opinions about specific
implementation details in constructive ways.

Regards,
Markus
