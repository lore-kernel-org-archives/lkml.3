Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3AKVJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:09:46 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:53558 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab3AKVJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:09:45 -0500
MIME-Version: 1.0
In-Reply-To: <50F070D8.2080109@zytor.com>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
	<201301111333.49238.trenn@suse.de>
	<CAE9FiQWPJdER++ZrkKx7cQpF0QvwBeghNjpFqK18pMNC0w20tw@mail.gmail.com>
	<1603289.LXteBtkifD@hammer82.arch.suse.de>
	<CAE9FiQU6RWH6cBKc9th3Eb2gCjcHfotbC1sYspQ7dU+cG=VMFA@mail.gmail.com>
	<50F070D8.2080109@zytor.com>
Date: Fri, 11 Jan 2013 13:09:43 -0800
X-Google-Sender-Auth: mdmK6By8fp_M-4bOxpKE-Vd0AVw
Message-ID: <CAE9FiQWEan4Vq-pbp6sgMWVFHwWygQ4Hq2wRsPH166+7w7L2yg@mail.gmail.com>
Subject: Re: [PATCH] x86 e820: only void usable memory areas in
 memmap=exactmap case
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Renninger <trenn@suse.de>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org, horms@verge.net.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 12:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/11/2013 11:59 AM, Yinghai Lu wrote:
>> On Fri, Jan 11, 2013 at 10:24 AM, Thomas Renninger <trenn@suse.de> wrote:
>>>> We may need to keep exactmap intact.
>>> Why?
>>> Kexec/kdump should have been the only user?
>>> If older/current kexec calls still add ACPI maps via memmap=X#Y,
>>> they should already exist in the original e820 map and fall off or
>>> get glued to one region if (wrongly) overlapping via sanitize_map.
>>
>> No, kexec/kdump is not the only user for memmap=exactmap.
>>
>
> Who is using it then, since you seem to know?

http://forums.gentoo.org/viewtopic-t-487476-highlight-proliant.html

http://forums.fedoraforum.org/archive/index.php/t-225347.html
