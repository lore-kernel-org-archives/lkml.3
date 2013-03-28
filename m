Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab3C1Gl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:41:27 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33558 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3C1Gl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:41:26 -0400
MIME-Version: 1.0
In-Reply-To: <51537F02.7090500@samsung.com>
References: <1364383410-15093-1-git-send-email-sachin.kamat@linaro.org>
	<51537F02.7090500@samsung.com>
Date: Thu, 28 Mar 2013 12:11:25 +0530
Message-ID: <CAK9yfHx2y7LTu1G6=6EDybOZdV_Tk2r=RbvEH58J3mQC0DfZJA@mail.gmail.com>
Subject: Re: [PATCH 1/2] extcon: max77693: Fix return value
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 28 March 2013 04:51, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> On 03/27/2013 08:23 PM, Sachin Kamat wrote:
>> Return the value obtained from the function instead of hardcoding.
>> Silences the following warning:
>> drivers/extcon/extcon-max77693.c:297 max77693_muic_set_path()
>> info: why not propagate 'ret' from max77693_update_reg() instead of (-11)?
>> drivers/extcon/extcon-max77693.c:310 max77693_muic_set_path()
>> info: why not propagate 'ret' from max77693_update_reg() instead of (-11)?
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
[snip]

>>       dev_info(info->dev,
> As my comment about "extcon: max8997: Fix return value",
> I wish to receive one patch which modify all of return value with 'ret'
> in extcon-max77693.c.

Resent both patches as per your suggestion.


-- 
With warm regards,
Sachin
