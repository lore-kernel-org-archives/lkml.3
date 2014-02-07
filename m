Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaBGPqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:46:34 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:55406 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaBGPqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:46:32 -0500
Message-ID: <52F4FFD5.5070808@lwfinger.net>
Date: Fri, 07 Feb 2014 09:46:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>, Johannes Berg <johannes@sipsolutions.net>
CC: Calvin Owens <jcalvinowens@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ieee80211: Print human-readable disassoc/deauth reason
 codes
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>	<1391675824.12789.3.camel@jlt4.sipsolutions.net> <87r47fkrsj.fsf@purkki.adurom.net>
In-Reply-To: <87r47fkrsj.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 06:53 AM, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>
>> On Wed, 2014-02-05 at 19:44 -0600, Calvin Owens wrote:
>>> Create a function to return a descriptive string for each reason code,
>>> and print that instead of the numeric value in the kernel log. These
>>> codes are easily found on popular search engines, but one is generally
>>> not able to access the internet when dealing with wireless connectivity
>>> issues.
>>
>> I believe both iw and wpa_supplicant already have the reason code
>> printout, and if you're diagnosing connectivity issues then you're
>> probably using those anyway (e.g. iw event -t), so I don't really see
>> much point in adding this to the kernel?
>
> FWIW I find this useful. When I have connection problems I rarely look
> at wpasupplicant, mostly I'm so lazy that I just check from the kernel
> log what's happening. Just my 0.02 EUR.

I would also find it useful. I assist with wireless problems on the openSUSE 
Forum, and there we are lucky if we get dmesg output. When we do and it contains 
a deauthentication reason, I always need to bring up a web page to interpret the 
output. With this change, one step could be skipped.



