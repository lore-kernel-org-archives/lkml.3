Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaLCXMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:12:08 -0500
Received: from mout.web.de ([212.227.15.14]:56477 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaLCXMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:12:06 -0500
Message-ID: <547F98A3.7090509@users.sourceforge.net>
Date: Thu, 04 Dec 2014 00:11:31 +0100
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
References: <20141202085950.GA13434@mwanda> <547F0297.6030202@users.sourceforge.net> <20141203124511.GR5048@mwanda> <547F0977.7090908@users.sourceforge.net> <20141203132002.GT5048@mwanda> <547F0F2A.3060708@users.sourceforge.net> <547F1942.5060502@broadcom.com> <547F33AC.50002@users.sourceforge.net> <547F60E5.50705@broadcom.com>
In-Reply-To: <547F60E5.50705@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:uaVd1TktEtqbpYxgMFrO6XO11OaDniKzlYIAa3MDal1jNmCfLvv
 +fa8OtqIbVHWNSlZ1POZPo5fueZZA7PUFhA4E61620Qdcv7cOJyYG49mCCSVtJUBP6nxIt9
 CaBY1hnOlSNKZZaT6KSlU07kesPWsibV1f53GqnupYPy/sUpdVmnv8N75dZAHvBMDr1ew7F
 eU+1vP7lBfgU8gbbkZDUA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please provide your point of view.

I would like to interpret the key word "goto" from the C programming
language a bit more here so that a better common understanding can
eventually be achieved.

Strong opinions might be floating around for the consistent naming
of jump labels. My reasoning works like the following.

This key word could also be interpreted as two items "go" and "to",
couldn't it?
How much does this variation stress its meaning in a specific direction?

Some software developers would like to express the reason about
an unexpected event at the jump source. But I guess that this approach
increases the risk for a popular story like "goto fail;", doesn't it?
I would prefer not to specify "go to failure".

So I find that there are more variants possible to stress the jump target.
Examples:
* Failure_exit
* out_memory_release
* unregister_item

Regards,
Markus
