Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaE1UBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:01:21 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37188 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaE1UBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:01:19 -0400
Message-ID: <5386408B.2050407@linaro.org>
Date: Wed, 28 May 2014 13:01:15 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Heesub Shin <heesub.shin@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>,
        Dongjun Shin <d.j.shin@samsung.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] staging: ion: system heap and page pool fixes
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com> <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
In-Reply-To: <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 11:52 PM, Heesub Shin wrote:
> Hi,
>
> Here is my patchset with some modification, hoping reviews or comments
> from you guys.
>
> v2:
>  o No changes in the code, just reworded changelog
>  o Reorder patch 

Ran this through Colin's ion-unit-tests and saw no changes in the
results on x86_64, i386(compat), and arm. So looks ok there.

Would still be good to have Colin's ack, but here's my qualified
tested-by line...

(Basic Unit)Tested-by: John Stultz <john.stultz@linaro.org>

thanks
-john

