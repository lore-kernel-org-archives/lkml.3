Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab3LFGFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:05:53 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:34643 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3LFGFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:05:52 -0500
Message-ID: <52A16932.8020909@gmail.com>
Date: Fri, 06 Dec 2013 08:05:38 +0200
From: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ivaylo DImitrov <ivo.g.dimitrov.75@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "omar.ramirez@copitl.com" <omar.ramirez@copitl.com>, pali.rohar@gmail.com,
        pavel@ucw.cz, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] Staging: TIDSPBRIDGE: Remove UUID helper
References: <1385917660-2676-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1385917660-2676-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 01.12.2013 19:07, Ivaylo DImitrov wrote:
> From: Ivaylo Dimitrov <freemangordon@abv.bg>
>
> Custom uuid helper function is needed only in rmgr/dbdcd.c and doesn't
> need to be exported. It can also be made way simpler by using sscanf.
>
> Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
> ---
>   drivers/staging/tidspbridge/Makefile               |    2 +-
>   drivers/staging/tidspbridge/gen/uuidutil.c         |   85 --------------------
>   .../tidspbridge/include/dspbridge/uuidutil.h       |   18 ----
>   drivers/staging/tidspbridge/rmgr/dbdcd.c           |   42 +++++++++-
>   4 files changed, 39 insertions(+), 108 deletions(-)
>   delete mode 100644 drivers/staging/tidspbridge/gen/uuidutil.c
>

I guess the initial mail somehow didn't make it through your spam filter:
https://lkml.org/lkml/2013/12/1/70

Regards,
Ivo
