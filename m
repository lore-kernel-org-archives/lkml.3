Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaCEGBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:01:31 -0500
Received: from top.free-electrons.com ([176.31.233.9]:46481 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751174AbaCEGB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:01:29 -0500
Message-ID: <5316BDB7.5060004@free-electrons.com>
Date: Wed, 05 Mar 2014 07:01:27 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Levente Kurusa <levex@linux.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: How to get rid of IRQF_DISABLED for good?
References: <53063F09.9000102@free-electrons.com> <CAAsK9AGpuxCvQ_m+dJh_T72dHGaU3TU6AgSyWdf5YtzzJx==Vw@mail.gmail.com>
In-Reply-To: <CAAsK9AGpuxCvQ_m+dJh_T72dHGaU3TU6AgSyWdf5YtzzJx==Vw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Levente,

Thank you for your good advise!

On 02/20/2014 07:17 PM, Levente Kurusa wrote:
> 2014-02-20 18:44 GMT+01:00 Michael Opdenacker
> <michael.opdenacker@free-electrons.com>:
>> Hi,
>>
>> In spite of the patches I have been sending (and resending!) over the
>> past months, there are still 118 occurrences of the idle IRQF_DISABLED
>> flag in the kernel code. This corresponds to 31 patches which haven't
>> been accepted yet.
>>
>> What would you advise to get rid of IRQF_DISABLED for good?
>>
>>   * Send a treewide patch removing the last occurrences in one shot,
>>     bypassing the regular maintainers? Who could take it?
> Andrew Morton would take it to his -mm tree.
> This, IMO, seems to be the best solution to circumvent unresponsive/uncaring
> maintainers.
>
>>   * Remove the definition of IRQF_DISABLED to force the individual
>>     maintainers (and out of tree drivers!) to update their code? It
>>     could be a way of seeing which code isn't maintained any more ;)
> No, every single patch has to be 'bisectable' meaning that when you bisect
> you should be able to build every single patch as is.
>
>>   * Continue to resend the patches for a few more cycles, until the
>>     corresponding maintainers can no longer bear the discredit?
> Maybe once more, if they don't reply, send it to Andrew Morton as well
> and CC a few people who know your work is good so that they can ACK it.
I sent my patches once more, and will see which ones remain. Then I will
send the changes to Andrew Morton as you suggested.

Thanks again!

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

