Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3HPIcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:32:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56326 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab3HPIcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:32:00 -0400
MIME-Version: 1.0
In-Reply-To: <520DD9CA.90305@roeck-us.net>
References: <520C9A39.3030808@roeck-us.net>
	<CAMo8BfKyqZYMkh96wyZSpYUpXwqFQZkco=XgtjUrNG-jSzW5pA@mail.gmail.com>
	<20130816054823.GB28445@thor.bakeyournoodle.com>
	<CAMo8Bf+veq_DU7-hnB0yySy6YWpwU2TYx3U9e89c_m8Mv9Cv5w@mail.gmail.com>
	<520DD9CA.90305@roeck-us.net>
Date: Fri, 16 Aug 2013 12:31:59 +0400
Message-ID: <CAMo8BfLvVk+2CyQD28otU265J4rvbt0Eg11Vqr4u4zjKjrTanw@mail.gmail.com>
Subject: Re: Linux kernel cross-compilers
From: Max Filippov <jcmvbkbc@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 11:50 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 08/16/2013 12:22 AM, Max Filippov wrote:
>>
>> On Fri, Aug 16, 2013 at 9:48 AM, Tony Breeds <tony@bakeyournoodle.com>
>> wrote:
>>>
>>> On Thu, Aug 15, 2013 at 01:46:16PM +0400, Max Filippov wrote:
>>>
>>>> Yes, xtensa compiler/linker is known to have issues with link-time
>>>> relaxation; e.g. it may fail to build linux image without
>>>> CONFIG_LD_NO_RELAX.
>>>
>>>
>>> Is there something I can do at linker build time to help with this?
>>
>>
>> I don't think so. Apparently it's not a linker configuration issue, it's a
>> bug.
>>
> CONFIG_LD_NO_RELAX doesn't help.
>
> For reference, here is the error:
>
> xtensa-linux-objcopy: Unable to change endianness of input file(s)
> make[2]: *** [arch/xtensa/boot/boot-elf/Image.o] Error 1
> make[1]: *** [boot-elf] Error 2
> make: *** [zImage] Error 2
>
> Oddly enough, I only see the problem on one of three servers.

Guenter,
can you share a complete build log with V=1?

-- 
Thanks.
-- Max
