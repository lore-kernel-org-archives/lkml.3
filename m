Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936325AbaBDWsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:48:52 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59055 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934007AbaBDWsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:48:47 -0500
Message-ID: <52F16E4C.3080207@linaro.org>
Date: Tue, 04 Feb 2014 14:48:44 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/37] 3.4.79-stable review
References: <20140204210055.992134150@linuxfoundation.org> <20140204215221.GA2127@bender.morinfr.org> <20140204221109.GA906@kroah.com> <20140204222203.GA6688@bender.morinfr.org> <20140204223150.GA2696@kroah.com>
In-Reply-To: <20140204223150.GA2696@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 02:31 PM, Greg Kroah-Hartman wrote:
> On Tue, Feb 04, 2014 at 11:22:05PM +0100, Guillaume Morin wrote:
>> On 04 Feb 14:11, Greg Kroah-Hartman wrote:
>>>>> Borislav Petkov <bp@alien8.de>
>>>>>     rtc-cmos: Add an alarm disable quirk
>>>> This is just one of the 3 patches posted by John Stultz on
>>>> http://git.linaro.org/people/john.stultz/linux.git/shortlog/refs/heads/stable/3.4/timefix
>>> I have no idea what that tree is, nor what I am supposed to do with it.
>> Ok, sorry. This is all coming from 
>> http://article.gmane.org/gmane.linux.kernel.stable/77575/
>>
>> I assumed you were aware of it because you participated in the thread
>> and one of the patch mentioned in this message (Borislav's change) is
>> applied to the 3.4 branch
> John said he would submit those patches after -rc2 came out, I wasn't
> aware that this specific patch was part of that series, sorry, should I
> drop it for now?

Yea. Hold off on it for now, I'll resubmit it after -rc2.

thanks
-john

