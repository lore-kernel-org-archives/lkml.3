Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaDWLTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:19:37 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:61826 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaDWLTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:19:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140423083547.GT26890@mwanda>
References: <20140423081842.GA7498@devel>
	<20140423083547.GT26890@mwanda>
Date: Wed, 23 Apr 2014 20:19:35 +0900
Message-ID: <CAHb8M2A8ABJ95vgvq-h0Pw9OVpY7DdzqGzyH2dKO8sNrS+OXug@mail.gmail.com>
Subject: Re: [PATCH] staging: silicom: remove redundant pci_get_drvdata() call
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, yongjun_wei@trendmicro.com.cn,
        rupert@rmuch.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-23 17:35 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> On Wed, Apr 23, 2014 at 05:18:42PM +0900, Daeseok Youn wrote:
>> The pci_get_drvdata() and checking NULL for dev are
>> called twice in while loop in is_bypass_dev().
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>> This patch has an warning from checkpatch.pl.
>> checkpatch.pl warning:
>> WARNING: Too many leading tabs - consider code refactoring
>
> No problem.  Those were there and worse before your patch.
>
> If someone wanted to fix these then just reverse every if condition in
> the function.
Ok. Thanks for comment.

Regards,
Daeseok Youn
>
> regards,
> dan carpenter
>
>
