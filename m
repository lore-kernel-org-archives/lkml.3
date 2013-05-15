Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009Ab3EOOFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:05:48 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:40754 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab3EOOFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:05:46 -0400
Message-ID: <FC7F5007EF934194A48587DB6A0DBCC0@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Borislav Petkov" <bp@alien8.de>, <linux-pm@vger.kernel.org>,
        "Len Brown" <len.brown@intel.com>, "Pavel Machek" <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "LKML" <linux-kernel@vger.kernel.org>, "X86 ML" <x86@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <devel@linuxdriverproject.org>, <olaf@aepfle.de>,
        "\"Andy Whitcroft\"" <apw@canonical.com>, <jasowang@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, <JBeulich@suse.com>
Cc: "Michal Hocko" <mhocko@suse.cz>
References: <20130514160108.GA5055@dhcp22.suse.cz> <925E2E537ECB4D0C8EA18467A4D20174@local.st.by> <20130515133405.GC5455@dhcp22.suse.cz> <293D65E8F6CE48768FF47E438C57ECD2@local.st.by> <20130515134656.GF5455@dhcp22.suse.cz>
Subject: Re: CONFIG_HYPERVISOR_GUEST=y   {-- replace -- CONFIG_PARAVIRT_GUEST=y {= { # CONFIG_HYPERVISOR_GUEST is not set } Re: 3.10-rc1 Fw: [PATCH 2/2] x86: Make Linux guest support optional
Date: Wed, 15 May 2013 17:05:42 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> >>>- select PARAVIRT_GUEST
>> >>>+ select HYPERVISOR_GUEST
>> >
>> >I might have missed the previous discussion but how does this relate to
>> >the original problem reported to this (https://lkml.org/lkml/2013/5/14/398)
>> >thread?
>> 
>> As example:
>> 
>> https://lkml.org/lkml/2013/5/14/398
>> ==
>> . . .
>> # CONFIG_HYPERVISOR_GUEST is not set
>> . . .
>> ==
>> 
>> >For record:
>> >$grep HYPERVISOR_GUEST .config
>> ># CONFIG_HYPERVISOR_GUEST is not set
>> 
>> 
>> Why not
>> CONFIG_HYPERVISOR_GUEST=y
> 
> This is unrelated to the issue discussed in this thread.

 Yes: Is another 1-2 problem[s], but is problem[s]:


==
TO All:

 Please, replace
CONFIG_PARAVIRT_GUEST=y
 with
CONFIG_HYPERVISOR_GUEST=y
==

==
Is good?

CONFIG_PARAVIRT_GUEST in arch/ia64 :

./linux-3.10-rc1/arch/ia64/include/asm/native/
inst.h
./linux-3.10-rc1/arch/ia64/configs/
xen_domu_defconfig
./linux-3.10-rc1/arch/ia64/include/asm/
hw_irq.h
iosapic.h
paravirt.h

==
 . . .
#ifdef CONFIG_PARAVIRT_GUEST

#define PARAVIRT_HYPERVISOR_TYPE_DEFAULT 0
#define PARAVIRT_HYPERVISOR_TYPE_XEN  1
 . . .
==

==

 Comments ?

Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/

