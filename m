Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaHaStq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 14:49:46 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57659 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaHaStn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 14:49:43 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <54036E45.2050604@roeck-us.net>
Date: Sun, 31 Aug 2014 11:49:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, linux-cris-kernel@axis.com,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: Re: Status of 'cris' architecture support in Linux kernel
References: <20140831175010.GA15408@roeck-us.net> <20140831183342.GA25437@ravnborg.org>
In-Reply-To: <20140831183342.GA25437@ravnborg.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2014 11:33 AM, Sam Ravnborg wrote:
> On Sun, Aug 31, 2014 at 10:50:10AM -0700, Guenter Roeck wrote:
>> The idea was to create a crisv32 kernel and initramfs to work with qemu
>> for the ongoing Linux kernel test project.
>>
>> After spending a number of days (and nights) on it, the results don't look
>> very encouraging.
>>
>> My overall conclusion is that 'cris' architecture support in the Linux kernel
>> is in bad shape, does not work anymore, and would require substantial effort
>> to get it into working state.
>>
>> Anyway, below are my individual findings. If there is an ongoing effort to
>> improve cris support in the upstream kernel, specifically support for crisv32,
>> please let me know. I'll be happy to test the resulting kernels.
>
> Jesper is on parental leave so do not expect any prompt reply from him.
>
>>
>> Individual findings:
>>
>> headers_install
>>
>> make ARCH=cris INSTALL_HDR_PATH=/tmp headers_install
>>
>> results in:
>>
>> ./scripts/Makefile.headersinst:14: arch/cris/include/uapi/asm/arch-v10/Kbuild:
>> 	No such file or directory
>> make[2]: *** No rule to make target `arch/cris/include/uapi/asm/arch-v10/Kbuild'.  Stop.
> I have already sent a fix for this that Michael said he wanted to deal with.
>

Hi Sam,

That is great. Note there is a second part besides the failure itself:
The resulting installed headers don't work and need a post-installation
patch, as mentioned in my previous e-mail. Would be great if you can
look into this as well (if you did not do so already).

Thanks,
Guenter

