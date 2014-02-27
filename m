Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaB0SMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:12:50 -0500
Received: from vivithemage.co.uk ([213.138.103.165]:45554 "EHLO
	mail.mage.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaB0SMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:12:49 -0500
Message-ID: <530F8020.3040000@mage.me.uk>
Date: Thu, 27 Feb 2014 18:12:48 +0000
From: "rs@mage.me.uk" <rs@mage.me.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, speakup@braille.uwo.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: speakup: buffers: Fixed a return value coding
 style issue.
References: <1393518402-24860-1-git-send-email-rs@mage.me.uk> <20140227164051.GA25183@kroah.com>
In-Reply-To: <20140227164051.GA25183@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------070703090107090505070208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070703090107090505070208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

When checking buffers.c with checkpatch.pl it throws the following 
error: drivers/staging/speakup/buffers.c:58: ERROR: return is not a 
function, parentheses are not required

I watched one of your talks, it's very informative and concise: 
http://www.youtube.com/watch?v=LLBrBBImJt4&feature=youtu.be

Thanks,
Reza Snowdon

On 27/02/14 16:40, Greg KH wrote:
> On Thu, Feb 27, 2014 at 04:26:42PM +0000, Reza Snowdon wrote:
>> Fixed a coding style issue.
>>
>> Signed-off-by: Reza Snowdon <rs@mage.me.uk>
>> ---
>>   drivers/staging/speakup/buffers.c |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/speakup/buffers.c b/drivers/staging/speakup/buffers.c
>> index 382973e..8d7caa7 100644
>> --- a/drivers/staging/speakup/buffers.c
>> +++ b/drivers/staging/speakup/buffers.c
>> @@ -55,7 +55,8 @@ static int synth_buffer_free(void)
>>
>>   int synth_buffer_empty(void)
>>   {
>> -	return (buff_in == buff_out);
>> +	int buff_comparison = (buff_in == buff_out);
>> +	return buff_comparison;
>
> What's wrong with the original code here?  If anything, just drop the
> (), but really, it's fine, leave it alone, it's obvious what is
> happening is ok.
>
> thanks,
>
> greg k-h
>


-- 
Regards,
Reza Snowdon

--------------070703090107090505070208
Content-Type: text/x-patch;
 name="0001-Staging-speakup-buffers-Fixed-a-return-coding-style-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Staging-speakup-buffers-Fixed-a-return-coding-style-.pa";
 filename*1="tch"

>From a2dda399463c20f63306e31b743e0c9c3be2ca3a Mon Sep 17 00:00:00 2001
From: Reza Snowdon <rs@mage.me.uk>
Date: Thu, 27 Feb 2014 17:57:59 +0000
Subject: [PATCH] Staging: speakup: buffers: Fixed a return coding style issue

When checking buffers.c with checkpatch.pl it throws the following error: drivers/staging/speakup/buffers.c:58: ERROR: return is not a function, parentheses are not required

Fixed error by removing parenthesis.

Signed-off-by: Reza Snowdon <rs@mage.me.uk>
---
 drivers/staging/speakup/buffers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/buffers.c b/drivers/staging/speakup/buffers.c
index 382973e..5e6ec13 100644
--- a/drivers/staging/speakup/buffers.c
+++ b/drivers/staging/speakup/buffers.c
@@ -55,7 +55,7 @@ static int synth_buffer_free(void)
 
 int synth_buffer_empty(void)
 {
-	return (buff_in == buff_out);
+	return buff_in == buff_out;
 }
 EXPORT_SYMBOL_GPL(synth_buffer_empty);
 
-- 
1.7.10.4


--------------070703090107090505070208--
