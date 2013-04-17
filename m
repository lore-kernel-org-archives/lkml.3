Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966046Ab3DQJQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:16:27 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60229 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965877Ab3DQJQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <5147BD6A.2010404@igel.co.jp>
References: <1363256545-30687-1-git-send-email-sachin.kamat@linaro.org>
	<5147BD6A.2010404@igel.co.jp>
Date: Wed, 17 Apr 2013 14:46:23 +0530
Message-ID: <CAK9yfHynreyh-0o_4srUay-WSK5QWp1bUKw829jNi=G+Z1w3Fw@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: uio_dmem_genirq: Use of_match_ptr() macro
From: Sachin Kamat <sachin.kamat@linaro.org>
To: hjk@hansjkoch.de
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2013 06:50, Damian Hobson-Garcia <dhobsong@igel.co.jp> wrote:
> On 2013/03/14 19:22, Sachin Kamat wrote:
>>
>> This eliminates having an #ifdef returning NULL for the case
>> when OF is disabled.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Damian Hobson-Garcia <dhobsong@igel.co.jp>
>> ---
>
> Thank you,
> Looks fine by me.
>
> Acked-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>

Hans,

Would you be picking up these patches for 3.10?


-- 
With warm regards,
Sachin
