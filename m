Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3HPHyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:54:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60958 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3HPHyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:54:44 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520DDAC2.2030609@roeck-us.net>
Date: Fri, 16 Aug 2013 00:54:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux kernel cross-compilers
References: <520C9A39.3030808@roeck-us.net> <20130816054732.GA28445@thor.bakeyournoodle.com>
In-Reply-To: <20130816054732.GA28445@thor.bakeyournoodle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 10:47 PM, Tony Breeds wrote:
> On Thu, Aug 15, 2013 at 02:07:05AM -0700, Guenter Roeck wrote:
>> Hi Tony,
>>
>> would it be possible to provide an arm64 cross-compiler on https://www.kernel.org/pub/tools/crosstool/ ?
>
> I have one built I just need to upload it.  I'll try and do it this
> weekend.
>
Would be great.

>> Also, the xtensa compiler fails for me with an odd error message on one of my servers.
>> Have you heard about any problems with it from others ?
>
> Nope.  Sorry, but it looks like you're being looked after there.
>
No far not helping. I had hoped it is a known problem that has been fixed with a later
gcc or binutils version, but it looks like it isn't widely seen.

>> c6x is supposed to be supported by gcc now. No idea if that helps anything, though.
>
> Thanks.  I have tried to build a 4.8.1 cx6 toolchain but It hasn't
> worked todate.  I'll keep trying as time permits.

Too bad. Thanks for trying!

Guenter

