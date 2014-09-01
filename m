Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaIADtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:49:21 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:47878 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaIADtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:49:20 -0400
From: Mikael Starvik <mikael.starvik@axis.com>
To: Sam Ravnborg <sam@ravnborg.org>
CC: Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Date: Mon, 1 Sep 2014 05:49:11 +0200
Subject: Re: Status of 'cris' architecture support in Linux kernel
Thread-Topic: Status of 'cris' architecture support in Linux kernel
Thread-Index: Ac/Fl7Eo0YtBplO7QDCtA9RZ+zZ4vg==
Message-ID: <48E8F969-A46E-4AA6-A78D-4141362A05B0@axis.com>
References: <20140831175010.GA15408@roeck-us.net>
 <20140831183342.GA25437@ravnborg.org>
In-Reply-To: <20140831183342.GA25437@ravnborg.org>
Accept-Language: sv-SE
Content-Language: sv-SE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper is actually back at work today but give him a few days to catch up.


> 31 aug 2014 kl. 20:51 skrev "Sam Ravnborg" <sam@ravnborg.org>:
> 
>> On Sun, Aug 31, 2014 at 10:50:10AM -0700, Guenter Roeck wrote:
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
>>    No such file or directory
>> make[2]: *** No rule to make target `arch/cris/include/uapi/asm/arch-v10/Kbuild'.  Stop.
> I have already sent a fix for this that Michael said he wanted to deal with.
> 
>    Sam
