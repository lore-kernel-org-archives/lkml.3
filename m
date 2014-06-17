Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884AbaFQUqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:46:05 -0400
Received: from mout.web.de ([212.227.17.11]:57817 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933496AbaFQUqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:46:03 -0400
Message-ID: <53A0A8FD.7080505@users.sourceforge.net>
Date: Tue, 17 Jun 2014 22:45:49 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Fabian Frederick <fabf@skynet.be>
CC: linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>
Subject: Re: [PATCH 1/1] scripts/coccinelle/free: add conditional kfree test
References: <1403034199-9824-1-git-send-email-fabf@skynet.be> <1403035539.2722.3.camel@joe-AO725>
In-Reply-To: <1403035539.2722.3.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:q+1RMUbUN8TrFdWJU1VFHPmc/YZkFYi+zi5j2IPvXc2n9Qx4G/U
 o7pQtL+ZRH9xqJ3KbU2OFx7yKjFZUF01fw0HQeXfg0MC1WcS/NTDAXdNZSmU7M/vfJSuLow
 F+UVTz38LeirNHNkDcxLVhI+Vpku8c4n4ErYH4YvQZNzELra1N2B/xrgwL8ED3PqTOr7nkC
 lHzIgtkRI6pNxkSOC0OgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This patch adds a trivial script warning on
>>
>> if(foo)
>> 	kfree(foo)
[...]
> You should probably add all of the unnecessary
> conditional tests that checkpatch uses:
[...]


Would you like to look at my previous update suggestion "Deletion of unnecessary
checks before specific function calls" again?
https://systeme.lip6.fr/pipermail/cocci/2014-March/000675.html
https://lkml.org/lkml/2014/3/5/344

Regards,
Markus

