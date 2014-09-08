Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaIHSIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:08:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58406 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbaIHSIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:08:35 -0400
Message-ID: <540DF078.3030601@zytor.com>
Date: Mon, 08 Sep 2014 11:07:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Pavel Machek <pavel@ucw.cz>
CC: John Stultz <john.stultz@linaro.org>,
        ksummit-discuss@lists.linuxfoundation.org,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        "Joseph S. Myers" <joseph@codesourcery.com>
Subject: Re: (Resend) 2038 Kernel Summit Discussion Fodder
References: <53EAAC95.7080301@linaro.org>	<CALAqxLWvSn2_6dakGiQ4VEtYHH2Dt7BL0pn5XHgLWOV4ePqhBw@mail.gmail.com>	<20140823222640.GA1382@xo-6d-61-c0.localdomain> <20140908185544.621022b6@alan.etchedpixels.co.uk>
In-Reply-To: <20140908185544.621022b6@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 10:55 AM, One Thousand Gnomes wrote:
>> Today, there's good chance there's linux somewhere in your car. (Dashboard,
>> entertainment system). People like to keep cars from 1910 working, and I suspect
>> that is not going to change.
>>
>> So yes, in 2038 people will be running 32bit linux.
>>
>> Whether there will be people putting 32bit linux into new devices is a question,
>> but I suspect answer is still yes.
> 
> I'm currently trying to add 64bit longlong support to an initial PCC 8086
> compiler port so I can fix that for some 16bit projects 8-)
> 
> My 8bit machines are mostly 2038 safe already.
> 

Back in 1985 I decided to Y2K-test my ABC800 8-bit computer.  It passed
(they had implemented a windowed year solution which breaks in 2070 or
2080, as I recall.)

	-hpa


