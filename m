Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934379Ab3FSJZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:25:16 -0400
Received: from intranet.asianux.com ([58.214.24.6]:60076 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755Ab3FSJZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:25:12 -0400
X-Spam-Score: -100.8
Message-ID: <51C178C4.7030400@asianux.com>
Date: Wed, 19 Jun 2013 17:24:20 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, sam@ravnborg.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH] arch: sparc: prom: looping issue, need additional length
 check in the outside looping
References: <51A6C8FA.3080408@asianux.com> <20130619.021342.853193458609177361.davem@davemloft.net>
In-Reply-To: <20130619.021342.853193458609177361.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 05:13 PM, David Miller wrote:
> From: Chen Gang <gang.chen@asianux.com>
> Date: Thu, 30 May 2013 11:35:22 +0800
> 
>>
>> When "cp >= barg_buf + BARG_LEN-2", it breaks internel looping 'while',
>> but outside loop 'for' still has effect, so "*cp++ = ' '" will continue
>> repeating which may cause memory overflow.
>>
>> So need additional length check for it in the outside looping.
>>
>> Also beautify the related code which found by "./scripts/checkpatch.pl"
> 
> Applied.
> 
> 

Thank you very much.


-- 
Chen Gang

Asianux Corporation
