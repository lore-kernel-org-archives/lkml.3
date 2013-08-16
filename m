Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3HPHui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:50:38 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59245 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3HPHuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:50:35 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520DD9CA.90305@roeck-us.net>
Date: Fri, 16 Aug 2013 00:50:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux kernel cross-compilers
References: <520C9A39.3030808@roeck-us.net> <CAMo8BfKyqZYMkh96wyZSpYUpXwqFQZkco=XgtjUrNG-jSzW5pA@mail.gmail.com> <20130816054823.GB28445@thor.bakeyournoodle.com> <CAMo8Bf+veq_DU7-hnB0yySy6YWpwU2TYx3U9e89c_m8Mv9Cv5w@mail.gmail.com>
In-Reply-To: <CAMo8Bf+veq_DU7-hnB0yySy6YWpwU2TYx3U9e89c_m8Mv9Cv5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 12:22 AM, Max Filippov wrote:
> On Fri, Aug 16, 2013 at 9:48 AM, Tony Breeds <tony@bakeyournoodle.com> wrote:
>> On Thu, Aug 15, 2013 at 01:46:16PM +0400, Max Filippov wrote:
>>
>>> Yes, xtensa compiler/linker is known to have issues with link-time
>>> relaxation; e.g. it may fail to build linux image without CONFIG_LD_NO_RELAX.
>>
>> Is there something I can do at linker build time to help with this?
>
> I don't think so. Apparently it's not a linker configuration issue, it's a bug.
>
CONFIG_LD_NO_RELAX doesn't help.

For reference, here is the error:

xtensa-linux-objcopy: Unable to change endianness of input file(s)
make[2]: *** [arch/xtensa/boot/boot-elf/Image.o] Error 1
make[1]: *** [boot-elf] Error 2
make: *** [zImage] Error 2

Oddly enough, I only see the problem on one of three servers.

Guenter

