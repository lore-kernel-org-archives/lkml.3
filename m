Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbaGHUNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:13:01 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62564 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbaGHUM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:12:59 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53BC50CA.4060501@roeck-us.net>
Date: Tue, 08 Jul 2014 13:12:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 000/125] 3.2.61-rc1 review
References: <lsq.1404846109.699842714@decadent.org.uk>
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 12:01 PM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.61 release.
> There are 125 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jul 10 19:01:49 UTC 2014.
> Anything received after that time might be too late.
>

Ben,

I am seeing a large number of build failures.

lib/nlattr.c: In function 'nla_parse':
lib/nlattr.c:201:3: error: dereferencing pointer to incomplete type
make[1]: *** [lib/nlattr.o] Error 1
make[1]: *** Waiting for unfinished jobs....

i386:defconfig is affected, so you should be able to test with it.
Build for x86_64 passes.

Guenter

