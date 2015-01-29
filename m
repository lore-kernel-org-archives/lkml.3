Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbbA2O5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:57:36 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:41071 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbA2O5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:57:35 -0500
Message-ID: <54CA4A59.7000905@linaro.org>
Date: Thu, 29 Jan 2015 16:57:29 +0200
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: efi: remove unneeded guid unparse
References: <1422542102-19348-1-git-send-email-ivan.khoronzhuk@linaro.org> <1422542869.21110.8.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1422542869.21110.8.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, sorry.
Just didn't note that it's picked up from linaro list.


On 01/29/2015 04:47 PM, Matt Fleming wrote:
> On Thu, 2015-01-29 at 16:35 +0200, Ivan Khoronzhuk wrote:
>> There is no reason to translate guid number to string here.
>> So remove it in order to not do unneeded work.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>   drivers/firmware/efi/efi.c | 5 -----
>>   1 file changed, 5 deletions(-)
> Why the resend? I already picked this commit up,
>
>    https://lkml.kernel.org/r/20150120223238.GC12079@codeblueprint.co.uk
>

