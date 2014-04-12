Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbaDLWkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 18:40:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57535 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaDLWkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 18:40:07 -0400
Message-ID: <5349C09D.8000906@zytor.com>
Date: Sat, 12 Apr 2014 15:39:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Christian Grothoff <christian@grothoff.org>
CC: Alejandra Morales <alejandra.morales@tum.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cryogenic: Enabling Power-Aware Applications on Linux
References: <9E3F9C2076C45D4783F09B90D5BE77CE1AEF7A@BADWLRZ-SWMBX13.ads.mwn.de> <20140411101926.GA27234@amd.pavel.ucw.cz> <534838E8.10005@grothoff.org> <20140411220517.GA1203@amd.pavel.ucw.cz> <53487FE7.2040604@grothoff.org> <20140412113653.GA10806@Nokia-N900>
In-Reply-To: <20140412113653.GA10806@Nokia-N900>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2014 04:36 AM, Pavel Machek wrote:
>>
>>> Hmm, but the API needs redoing, anyway, fcntl()?
>>
>> Depends --- while I like the idea, I did not hear enough to be
>> certain that having this feature embedded in such a non-modular
>> way was already the consensus (and I do not see a reasonable
>> way to change the API this way while maintaining the modularity
>> of the current code).
> 
> Being modular is not important for small piece of code like
> this. Having reasonable interface is...
> 

Yes, it is critical.

	-hpa


