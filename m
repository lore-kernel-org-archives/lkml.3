Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab3BGGp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:45:27 -0500
Received: from asix.com.tw ([113.196.140.82]:52507 "EHLO asix.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab3BGGpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:45:25 -0500
Message-ID: <51134D7B.5070709@asix.com.tw>
Date: Thu, 07 Feb 2013 14:45:15 +0800
From: Freddy <freddy@asix.com.tw>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: freddy@asix.com.tw
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0
 to gigabit ethernet adapter driver
References: <1360211794-4737-1-git-send-email-freddy@asix.com.tw> <20130206214525.5c5775fe@nehalam.linuxnetplumber.net>
In-Reply-To: <20130206214525.5c5775fe@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 01:45 PM, Stephen Hemminger wrote:
> On Thu,  7 Feb 2013 12:36:34 +0800
> Freddy Xin <freddy@asix.com.tw> wrote:
>
>> +struct {unsigned char ctrl, timer_l, timer_h, size, ifg; }
>> +AX88179_BULKIN_SIZE[] =	{
>> +	{7, 0x4f, 0,	0x12, 0xff},
>> +	{7, 0xf0, 1,	0x15, 0xff},
>> +	{7, 0xae, 7,	0x18, 0xff},
>> +	{7, 0xcc, 0x4c, 0x18, 8},
>> +};
>   Better to make it static, const, and add a couple
>   of line breaks.
>
>   static const struct {
>        unsigned char ctrl, timer_l, timer_h, size, ifg;
>   } AX88179_BULKIN_SIZE[] =	{
> 	{7, 0x4f, 0,	0x12, 0xff},
> 	{7, 0xf0, 1,	0x15, 0xff},
> 	{7, 0xae, 7,	0x18, 0xff},
> 	{7, 0xcc, 0x4c, 0x18, 8},
> };
Thank you, Stephen. I will fix these errors.
>

