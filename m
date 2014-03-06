Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaCFSR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:17:27 -0500
Received: from nm43-vm5.bullet.mail.bf1.yahoo.com ([216.109.114.236]:36538
	"EHLO nm43-vm5.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695AbaCFSR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:17:26 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2014 13:17:26 EST
X-Yahoo-Newman-Id: 959003.57596.bm@smtp218.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: OSlOpboVM1k6DkvVqFNV_xURyPkrumcxE__ta_OGhTaNVCz
 YQewTma0Cy61YBY_c0OAY4Tua5nJViQIBYq3yoVdLOBg5_C83m2w8vB4D9o1
 DWh_DBJd0kpivcELugfMrLtv0995_7IgSoF8fU5qTtA9.Zk55H71jtKB2Lhq
 pV0Hc4qBGB35oR7vdHv.9baHnjeEqioHn8yX84zmu5SHDDbHjCvG.QNUDQy9
 cSZODAB34Vj0UUCIN0RJ3_e5XCSkl9sLofJr3Dj7qkE8qUH6_TIEPfDoPLO_
 u.ugm7SoC7l4FypkMS7tGzOguvIKZ.xozyP8ywXaoeR1uwOocM8KyxbUuuyC
 c7vq5a8mA84ZARfUFyR9ck8wqPPoR0GuAcrLMvZFo2lUymiJg6Ms16lP6vhM
 Dz9Je.obKPz0hP.za6vVuRQ7a7mVy8NtfoJVrLSBQvE_P4POBNsu.MEolPPK
 l7iQP3rlHTXKo1m2rLtaKgpHuEUMmoL5ORnb71cqnrxf3XSRlIrvxI4yAPW3
 wq5wyQzVXbqU4YOMsh.fMii_a3fPpbbAHUkJ.4qis6i_VhCmG5t9unTkAIWp
 K6n6Zw0buHw9JKatM3SNKMxic8co73qVfnx3QmZkiRJIFCV5KNS_i7tDIqkz
 FGKeDGo1i5b9ERv9kYweAbqZa35PLjyXCfz6JgoifrPBAY45PhikF8F2Q4RG
 50RohAqMI0CQeCN8lbutnKpzOOCy6joNSEA.bWazHgjqabi3oqMVUtGdkyFg
 UnCMPKO4E9d9Z.6gBXMKtEa3AW262fv0G.G9zONCcJfoWLxn0Kw--
X-Yahoo-SMTP: u9r3j8eswBBsV5z1r5v0bR9cjPS77vatbJK.6sw-
X-Rocket-Received: from [192.168.1.24] (draconicpenguin1@173.68.253.136 with plain [98.139.211.125])
        by smtp218.mail.bf1.yahoo.com with SMTP; 06 Mar 2014 10:12:00 -0800 PST
Message-ID: <5318BA6F.3080604@yahoo.com>
Date: Thu, 06 Mar 2014 13:11:59 -0500
From: Brian Wong <draconicpenguin1@yahoo.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Victor Miasnikov <vvm@tut.by>, KY Srinivasan <kys@microsoft.com>,
        linux-kernel@vger.kernel.org
CC: "Abhishek Gupta (LIS)" <abgupta@microsoft.com>
Subject: Re: Linux does not use more than the startup RAM under Hyper-V with
 dynamic memory enabled RE: [PATCH 2/2] Drivers: hv: balloon: Online the hot-added
 memory "in context" Re: [PATCH 1/1] Drivers: hv:
References: <531813B4.7060205@yahoo.com> <53181489.6040000@yahoo.com> <B0EFDC0724C0400DBC0931FD129D1859@local.st.by> <921422bfecda43e9baaa42077509a61d@BY2PR03MB299.namprd03.prod.outlook.com> <A1DA03FDF9C54AD3BCD66D02EA8CA68A@local.st.by>
In-Reply-To: <A1DA03FDF9C54AD3BCD66D02EA8CA68A@local.st.by>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/2014 6:13 AM, Victor Miasnikov wrote:
> Hi!
>
> VVM>>  Question to Linux kernel team: may be patch
> VVM>> >>> [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory
> "in context"
> VVM>> can solve problems with dynamic memory hot add in Hyper-V VMs with
> Linux OS ?
>
> K.Y.S>  I will try to get my in-context onlining patches accepted upstream.
>
> Thanks!
>
> Feature dynamic memory hot add in Hyper-V VMs with Linux OS  -- is very
> usefull for Hyper-V sysadmins
> Stable work for this feature -- must be hi-priority task for developers
>
>
> Best regards, Victor Miasnikov
> Blog:  http://vvm.blog.tut.by/
>
>
> ----- Original Message ----- From: "KY Srinivasan"
> To: "Victor Miasnikov"; linux-kernel@vger.kernel.org; "Brian Wong"
> Cc: "Abhishek Gupta (LIS)"
> Sent: Thursday, March 06, 2014 1:23 PM
> Subject: RE: Linux does not use more than the startup RAM under Hyper-V
> with dynamic memory enabled RE: [PATCH 2/2]
> Drivers: hv: balloon: Online the hot-added memory "in context" Re:
> [PATCH 1/1] Drivers: hv:
>
>
> Victor,
>
> I will try to get my in-context onlining patches accepted upstream.
>
> K. Y
>
>> -----Original Message-----
>> From: Victor Miasnikov [mailto:vvm@tut.by]
>> Sent: Thursday, March 6, 2014 3:38 PM
>> To: linux-kernel@vger.kernel.org; Brian Wong
>> Cc: Abhishek Gupta (LIS); KY Srinivasan
>> Subject: Re: Linux does not use more than the startup RAM under Hyper-V
>> with dynamic memory enabled RE: [PATCH 2/2] Drivers: hv: balloon: Online
>> the hot-added memory "in context" Re: [PATCH 1/1] Drivers: hv:
>>
>
>
> ----- Original Message ----- From: "Victor Miasnikov"
> To:  linux-kernel@vger.kernel.org; "Brian Wong"
> Cc: "Abhishek Gupta (LIS)" ( zzzzzzzzzzzzzzz (at) microsoft.com>; "KY
> Srinivasan" zzzzzzzzzzz (at) microsoft.com
> Sent: Thursday, March 06, 2014 1:07 PM
> Subject: Re: Linux does not use more than the startup RAM under Hyper-V
> with dynamic memory enabled RE: [PATCH 2/2]
> Drivers: hv: balloon: Online the hot-added memory "in context" Re:
> [PATCH 1/1] Drivers: hv:
>
> Hi!
>
> Short:
>
> Question to Linux kernel team:
>
> may be patch
>
>>>> [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in
>>>> context"
>
> can solve problems with dynamic memory hot add in Hyper-V VMs with Linux
> OS ?
>
>
>
> Full:
>
> BW>> .., if I set the startup memory to 512 MB, and enable dynamic
> BW>> memory with a minimum of 512 MB and a maximum of 8192 MB,
> BW>>  the system will never allocate than 512 MB of physical memory
>
> BW>>
> BW>> Have I encountered a bug in the Hyper-V balloon driver?
> BW>>
>
> Unfortunately,  It's long story . . . :-(
>
> a)
>
> I already ( on January 09, 2014 2:18 PM )  write about problems with
> "Online the hot-added memory"  in "user space" see
> P.P.S.
>
> b)
>
>   See
>
> Bug 979257 -[Hyper-V][RHEL6.5][RFE]in-kernel online support for memory
> hot-add
> https://bugzilla.redhat.com/show_bug.cgi?id=979257
>
> (  Info from this topic may be interessant not only for RedHat users )
>
>
> b2)
>
> Detail about pathes related problem "Online the hot-added memory"  in
> "user space" :
>
>>>> [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in
>>>> context"
>>>>
>>>>
>>>> === 0001-Drivers-base-memory-Export-functionality-for-in-kern.patch
>>>>  . . .
>>>> +/*
>>>> + * Given the start pfn of a memory block; bring the memory
>>>> + * block online. This API would be useful for drivers that may
>>>> + * want to bring "online" the memory that has been hot-added.
>>>> + */
>>>> +
>>>> +int online_memory_block(unsigned long start_pfn) {  struct mem_section
>>>> +*cur_section;  struct memory_block *cur_memory_block;
>>>>
>>>>  . . .
>>>> ===
>>>>
>>>>
>>>> ==
>>>>  . . .
>>>> == 0002-Drivers-hv-balloon-Online-the-hot-added-memory-in-co.patch
>>>>   . . .
>>>>    /*
>>>> -   * Wait for the memory block to be onlined.
>>>> -   * Since the hot add has succeeded, it is ok to
>>>> -   * proceed even if the pages in the hot added region
>>>> -   * have not been "onlined" within the allowed time.
>>>> +   * Before proceeding to hot add the next segment,
>>>> +   * online the segment that has been hot added.
>>>>     */
>>>> -  wait_for_completion_timeout(&dm_device.ol_waitevent, 5*HZ);
>>>> +  online_memory_block(start_pfn);
>>>>
>>>>   }
>
>
>
>
> c)
>
>   Before apply patches ( see in P.S. about native udev-script) we are
> need use one of this methods:
>
> http://social.technet.microsoft.com/Forums/en-US/8e1994b9-9ca1-4411-ad8e-25e6b1ee28e1/dynamic-memory-on-linux-vm?forum=linuxintegrationservices
>
>
>
>
> c1)
>
> "/bin/cp method" by Nikolay Pushkarev :
>
> Following udev rule works slightly faster for me (assuming that memory0
> bank always in online state):
>
> SUBSYSTEM=="memory", ACTION=="add",
> DEVPATH=="/devices/system/memory/memory[1-9]*",
> RUN+="/bin/cp /sys$devpath/../memory0/state /sys$devpath/state"}}
>
> ( VVM : of course all need be place in one line, 2 line in this msg. --
> only for good visual formating reasons )
>
>
> c2)
>
> udev rule using "putarg" by Nikolay Pushkarev :
>
>
> Even "/bin/cp method" udev rule work time to time not as need :-(
>
>
> As a result, Nikolay Pushkarev write a program putarg.c, that is even
> faster than "/bin/cp method" :
>
> ==
> #include <stdio.h>
> #include <fcntl.h>
> #include <sys/ioctl.h>
> #include <string.h>
> int main(int argc, char** argv) {
>   int i, fd;
>   if (argc < 2) return 0;
>   if ((fd = open(argv[1], O_RDWR)) < 0) return 1;
>   for (i = 2; i < argc; i++) {
>     if (write(fd, argv[i], strlen(argv[i])) < 0) {
>       close(fd);
>       return i;
>     }
>   }
>   close(fd);
>   return 0;
> }
> ==
>
> The first argument - the name of the output file ,
> and argument number 2 ( and all subsequent (  if exist ) ) - are text
> that are wiil be written in output file.
>
>
> Compile source code to executable file by run command:
> gcc -o putarg -s putarg.c
>
> The resulting binary need be placed an accessible location , such as
> /usr/bin, or wherever you want.
>
>
> Now udev rule using "putarg" can be written as :
>
> SUBSYSTEM=="memory", ACTION=="add", RUN+="/usr/bin/putarg
> /sys$devpath/state online"
>
>
> This complex solutions ( compiled file and udev-rule ) works
> exceptionally fast.
>
>
>
>
>
> Best regards, Victor Miasnikov
> Blog:  http://vvm.blog.tut.by/
>
> P.S.
>
> Nikolay Pushkarev about standart udev-script :
>
> {{
>
> Strange, that the native udev-script
>
> SUBSYSTEM=="memory", ACTION=="add", ATTR{state}="online"
>
>
> triggered somehow through time ( VVM: very often not work as need )
>
>
> }}
>
>
>
> P.P.S.
>
> ----- Original Message ----- From: "Victor Miasnikov"
> To: "Dan Carpenter"; "K. Y. Srinivasan" ; <linux-kernel@vger.kernel.org>
> Cc: "Greg KH" ; <devel@linuxdriverproject.org>; <olaf (at) aepfle.de>;
> ""Andy Whitcroft"" <zzzzzzzzzzzz (at)
> canonical.com>;
> <jasowang (at) redhat.com>
> Sent: Thursday, January 09, 2014 2:18 PM
> Subject: RE: [PATCH 2/2] Drivers: hv: balloon: Online the hot-added
> memory "in context" Re: [PATCH 1/1] Drivers: hv:
> Implement the file copy service
>
>
> Hi!
>
>> Is there no way we could implement file copying in user space?
>
>
>   For "file copy service"  "user space"  may be pretty good
>
> But I ( and other Hyper-V sysadmin)  see non-Ok ( in "political correct"
> terminalogy) results with "hv: balloon: Online
> the hot-added memory" in "user space"
>
>
> ==
> [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in context"
> ==
>
>
> What news?  Roadmap?
>
>
> Best regards, Victor Miasnikov
> Blog:  http://vvm.blog.tut.by/
>
>
>
>
> P.P.S.
>
> ----- Original Message ----- From: "Brian Wong"
> To: <linux-kernel@vger.kernel.org>
> Sent: Thursday, March 06, 2014 9:24 AM
> Subject: Re: Linux does not use more than the startup RAM under Hyper-V
> with dynamic memory enabled
>
>
> On 3/6/2014 1:20 AM, Brian Wong wrote:
>
>    . . .
>
>> The kernel is built with the full set of Hyper-V drivers, including the
>> key "Microsoft Hyper-V Balloon Driver" as well as memory hot-add and
>> hot-remove functionality. This is happening with both the Gentoo-patched
>> 3.10.32 kernel and the vanilla 3.12.5 kernel. The host machine has a
>> total of 24 GB of memory.
>>
>> For now, I am working around the issue by starting the VM with the
>> startup memory set to the maximum and letting Hyper-V take the usused
>> memory back when it is not in use. The VM will then get the extra memory
>> when it needs it.
>>
>> Have I encountered a bug in the Hyper-V balloon driver?
>>
>
> Just a correction: the vanilla kernel version is 3.13.5, not 3.12.5.
> Sorry for any confusion.
>

So can I expect to see this patched by the next kernel version?

-- 
Brian Wong
http://www.fierydragonlord.com
