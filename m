Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbbAMHIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 02:08:44 -0500
Received: from box2.japko.eu ([91.121.152.53]:59613 "EHLO box2.japko.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbbAMHIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 02:08:43 -0500
Date: Tue, 13 Jan 2015 08:06:48 +0100
From: Krzysztof Adamski <k@japko.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: whitespace checkpatch warning fix.
Message-ID: <20150113070648.GH30114@box2.japko.eu>
References: <20141222160834.GA11241@box2.japko.eu>
 <20150113034134.GB16095@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20150113034134.GB16095@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 07:41:34PM -0800, Greg Kroah-Hartman wrote:
>On Mon, Dec 22, 2014 at 05:08:34PM +0100, Krzysztof Adamski wrote:
>> This fixes following checkpatch.pl error:
>> ERROR: space prohibited before that ',' (ctx:WxW)
>>
>> Signed-off-by: Krzysztof Adamski <k@japko.eu>
>> ---
>> drivers/staging/vt6656/rxtx.c |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
>> index ea5140a..5a18e26 100644
>> --- a/drivers/staging/vt6656/rxtx.c
>> +++ b/drivers/staging/vt6656/rxtx.c
>> @@ -55,7 +55,7 @@ static const u16 vnt_fb_opt0[2][5] = {
>>
>> static const u16 vnt_fb_opt1[2][5] = {
>> 	{RATE_12M, RATE_18M, RATE_24M, RATE_24M, RATE_36M}, /* fallback_rate0 */
>> -	{RATE_6M , RATE_6M,  RATE_12M, RATE_12M, RATE_18M}, /* fallback_rate1 */
>> +	{RATE_6M,  RATE_6M,  RATE_12M, RATE_12M, RATE_18M}, /* fallback_rate1 */
>> };
>>
>> #define RTSDUR_BB       0
>> --
>> 1.7.10.4
>
>Again resend?

Sorry, it was my first attempt at getting some patch to upstream kernel.  
I was following your advice about being persistent:
http://www.reddit.com/r/linux/comments/2ny1lz/im_greg_kroahhartman_linux_kernel_developer_ama/cmvltqk

Next time I'll wait much longer.
