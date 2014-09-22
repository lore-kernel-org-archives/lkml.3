Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaIVGmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 02:42:07 -0400
Received: from mail.southpole.se ([37.247.8.11]:34182 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaIVGmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 02:42:02 -0400
X-Greylist: delayed 1096 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2014 02:42:02 EDT
Message-ID: <541FC06D.4030102@southpole.se>
Date: Mon, 22 Sep 2014 08:23:41 +0200
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: linux@openrisc.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] openrisc: Support both old (or32) and new (or1k) toolchain
References: <1410210049-30800-1-git-send-email-linux@roeck-us.net> <541BB786.1070700@roeck-us.net> <20140922025334.GA19719@chokladfabriken.org> <541F9D86.4000506@roeck-us.net>
In-Reply-To: <541F9D86.4000506@roeck-us.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.4.3(14246) on assp.southpole.se
X-Assp-ID: assp.southpole.se 67022-13927
X-Assp-Session: 7F93851DD2C8 (mail 1)
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On 09/22/2014 05:54 AM, Guenter Roeck wrote:
> On 09/21/2014 07:53 PM, Stefan Kristiansson wrote:
>> On Thu, Sep 18, 2014 at 09:56:38PM -0700, Guenter Roeck wrote:
>>> ping ... comments / feedback anyone ?
>>>
>>> Guenter
>>>
>>
>> FWIW, I've tested this and it works fine.
>>

Thanks, the patch is fine... will apply.  It's a nice solution to an
icky problem...

/Jonas

> Hi Stefan,
>
> Great, thanks a lot for testing. Any idea if Jonas is available to
> send it upstream,
> or should I try to send it to Linus directly ?


