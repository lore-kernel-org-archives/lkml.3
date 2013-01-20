Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab3ATNek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 08:34:40 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:46956 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3ATNei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 08:34:38 -0500
Message-ID: <50FBF25C.4030604@ahsoftware.de>
Date: Sun, 20 Jan 2013 14:34:20 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tom St Denis <tstdenis@elliptictech.com>
CC: Borislav Petkov <bp@alien8.de>, Eric Dumazet <erdnetdev@gmail.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        David Miller <davem@davemloft.net>,
        steffen klassert <steffen.klassert@secunet.com>,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Mike Galbraith <bitbucket@online.de>
Subject: Re: IPsec AH use of ahash
References: <313650836.93071.1358686587647.JavaMail.root@elliptictech.com>
In-Reply-To: <313650836.93071.1358686587647.JavaMail.root@elliptictech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.01.2013 13:56, schrieb Tom St Denis:

> You should really try running checkpatch.pl over code that's already in the kernel before you call out new contributors on it.
>
> How is this supposed to not be adversarial when I can't even use the Kernel source itself as a reference?

In case of the kernel the chicken and egg problem can be answered 
without any questions, most source existed before checkpatch.pl (evolved 
to the current state).

Regards,

Alexander
