Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaLCQBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:01:09 -0500
Received: from mout.web.de ([212.227.17.11]:55572 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaLCQBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:01:07 -0500
Message-ID: <547F33AC.50002@users.sourceforge.net>
Date: Wed, 03 Dec 2014 17:00:44 +0100
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
References: <20141202085950.GA13434@mwanda> <547F0297.6030202@users.sourceforge.net> <20141203124511.GR5048@mwanda> <547F0977.7090908@users.sourceforge.net> <20141203132002.GT5048@mwanda> <547F0F2A.3060708@users.sourceforge.net> <547F1942.5060502@broadcom.com>
In-Reply-To: <547F1942.5060502@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:a3KXUwfNusSYGa4+WA1GSWoXAuJ7y0/3XFrBNealyxzn+6vuiFn
 cWpGGjXvoBTHJ1lgV4ZM7GQdPyPcpglm9VPYavF0+AfA+bBHCy/5FlFBsuy4mqm0wIgiJMa
 QRNI+7vfCr/CuC8ydChmop07yHCSL6v1sc9tRedXfYHfYCa04hZlQgTu5Yo/fMUAIB4E4MT
 IxfGzJb649/T3CvlXXjiw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Which name pattern do you find more appropriate in such
>> an use case?
> 
> I think Dan wants the label to be descriptive about the tasks
> needed in the exception handling itself.

I would usually prefer also such a target-oriented labelling
for the affected identifiers.
How are the chances to express an expectation in this direction
unambiguously for the proposed coding style update?


> This makes sense as the exception handling steps may be reused
> for different failures in the code.

I would stress a different reason from my point of view.

Regards,
Markus
