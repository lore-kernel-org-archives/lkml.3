Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaHGTWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:22:10 -0400
Received: from outrelay08.libero.it ([212.52.84.112]:52643 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaHGTWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:22:09 -0400
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A0C0208.53E3D1DA.0123,ss=1,re=0.000,fgs=0
X-libjamoibt: 1823
Message-ID: <53E3D330.7060307@inwind.it>
Date: Thu, 07 Aug 2014 21:27:44 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Jean Delvare <jdelvare@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] Export the temperatures via hwmon
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it> <1407359103-6012-6-git-send-email-kreijack@inwind.it> <20140806231803.GA5643@roeck-us.net> <53E31694.8050107@gmail.com> <53E31AB0.6070604@roeck-us.net> <20140807085235.2c0e63dd@endymion.delvare> <53E32C77.5000804@roeck-us.net> <53E3BC48.4020304@inwind.it> <20140807181611.GA7679@roeck-us.net>
In-Reply-To: <20140807181611.GA7679@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 08:16 PM, Guenter Roeck wrote:
> On Thu, Aug 07, 2014 at 07:50:00PM +0200, Goffredo Baroncelli wrote:

>> When (if) these patches will be accepted I want to write another solution,
>> but definitely not now. And even if it would work for me, it is very likely 
>> that will  be accepted because nobody is able to test it on all hardware.
>>
> Might have been easier to just drop all this non-standard code and instantiate
> the adm1030 using the adm1031 driver instead.

I really like the idea, and this is a possible future work; but now we can't. 

We have to suppose that the current driver work (they stopped to work because
it was changed the i2c api) and because I can't test a change on
all the apple hardware (powermac, apple laptop...), I am allowed to make only 
very small changes.

My (our) first goal is to bring to life *this* driver.

I repeat I am fully convinced that re-using the "official" i2c drive/client
is the "right thing to do" (tm). But due to the lacking of the hardware where it
is possible to test this module, we need to be very conservative.

> 
> Guenter
>
Goffredo


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
