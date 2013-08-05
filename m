Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab3HEEBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 00:01:12 -0400
Received: from mail.ispras.ru ([83.149.199.45]:57453 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab3HEEBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 00:01:10 -0400
Message-ID: <51FF2384.2070008@ispras.ru>
Date: Mon, 05 Aug 2013 08:01:08 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jouni Malinen <j@w1.fi>, "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] hostap: do not return positive number on failure path
 in prism2_open()
References: <1375672708-3017-1-git-send-email-khoroshilov@ispras.ru> <1375673616.3133.23.camel@joe-AO722>
In-Reply-To: <1375673616.3133.23.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 07:33 AM, Joe Perches wrote:
> On Mon, 2013-08-05 at 07:18 +0400, Alexey Khoroshilov wrote:
>> prism2_open() as an .ndo_open handler should not return positive numbers
>> in case of failure, but it does return 1 in a couple of places.
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
> How?
>
> http://linuxtesting.org/project/ldv
> http://linuxtesting.org/results/ldv
>
> Shows defects and patches to fix them, but not any script
> used to find it.
There is a link to build instructions there:
http://forge.ispras.ru/projects/ldv/wiki/Downloading_and_Building_LDV

Currently it requires some efforts to install all the dependencies, the
simplest way is to use puppet script for Ubuntu 12.04 that you can find
in the repository.

--
Alexey
