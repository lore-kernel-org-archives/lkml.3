Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaLCMvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:51:32 -0500
Received: from mout.web.de ([212.227.17.12]:63885 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbaLCMva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:51:30 -0500
Message-ID: <547F0741.1090808@users.sourceforge.net>
Date: Wed, 03 Dec 2014 13:51:13 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Julia Lawall <julia.lawall@lip6.fr>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Coccinelle <cocci@systeme.lip6.fr>, backports@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [patch] CodingStyle: add some more error handling guidelines
References: <20141202085950.GA13434@mwanda> <547F0297.6030202@users.sourceforge.net> <547F0465.407@broadcom.com>
In-Reply-To: <547F0465.407@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:GXuIH1GiAek40o1s/vMvU/SNtynlG1/ybGVgDIU3G1hkPS8KB/7
 Eoa7SZ/hoRlh12UMxdRnbYT3pPkB+dzfn11k4l7Dxo5IyvLEfQWV/XnXOm/KZRfKraBh0fR
 NAG+h94jRmBtFUHLZhnaROc7jTHIwOV4DSVidXyaAEp1MxS+ei1/ATZLPMJ3oiGuYQF9pdp
 KlEwe2o6IlrwROzTLpuOw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> * To which source code place should the word "location" refer to?
>>    - jump source
>>    - jump target
> 
> I think you digested the paragraph in too small bits.

I would prefer to reduce the probability for misunderstandings of the 
proposed wording a bit more.


> The term "goto location" looks synonymous to "jump source" to me.

I would interpret it differently because of the specific placement of this key word
before an other term.

Regards,
Markus
