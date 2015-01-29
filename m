Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbbA2NiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:38:23 -0500
Received: from thoth.sbs.de ([192.35.17.2]:46890 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758265AbbA2NiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:38:17 -0500
Message-ID: <54CA37AD.7030308@siemens.com>
Date: Thu, 29 Jan 2015 14:37:49 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Ben Widawsky <ben@bwidawsk.net>, Borislav Petkov <bp@suse.de>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v11 01/28] scripts/gdb: Add infrastructure
References: <cover.1422514006.git.jan.kiszka@siemens.com> <39c235fa6c349bf025f957a1913c2e63be5b87c5.1422514006.git.jan.kiszka@siemens.com> <54CA343B.6060005@suse.cz>
In-Reply-To: <54CA343B.6060005@suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-29 14:23, Michal Marek wrote:
> On 2015-01-29 07:46, Jan Kiszka wrote:
>> --- a/scripts/Makefile
>> +++ b/scripts/Makefile
>> @@ -36,6 +36,7 @@ subdir-$(CONFIG_MODVERSIONS) += genksyms
>>  subdir-y                     += mod
>>  subdir-$(CONFIG_SECURITY_SELINUX) += selinux
>>  subdir-$(CONFIG_DTC)         += dtc
>> +subdir-$(CONFIG_GDB_SCRIPTS) += gdb
>>  
>>  # Let clean descend into subdirs
>> -subdir-	+= basic kconfig package
>> +subdir-	+= basic kconfig package gdb
> 
> The second assignment is superfluous. basic, kconfig and package are
> listed there, because they are built explicitly by the toplevel Makefile
> and not during the recursion.

Left-over from the pre-CONFIG_GDB_SCRIPTS times. Update will follow.

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
