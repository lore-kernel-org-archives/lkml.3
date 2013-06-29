Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3F2Mj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 08:39:59 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40158 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3F2Mj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 08:39:58 -0400
Message-ID: <51CED59E.2030307@gmail.com>
Date: Sat, 29 Jun 2013 14:39:58 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: Takashi Iwai <tiwai@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Kay Sievers <kay@redhat.com>
Subject: Re: udevd cannot modprobe snd-hda-intel with 3.9.8
References: <51CDD1B0.70607@gmail.com> <201306282208.23429.s.L-H@gmx.de>
In-Reply-To: <201306282208.23429.s.L-H@gmx.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

Il 28/06/2013 22:08, Stefan Lippers-Hollmann ha scritto:
> Hi
>
> On Friday 28 June 2013, Riccardo Magliocchetti wrote:
>> Hello,
>>
>> at boot udev (175-7.2 from debian unstable) blocks for maybe 30 seconds
>> and then gives (handcopied)
>>
>>    timeout: killing '/sbin/modprobe -b
>> pci:v00008086d0000293Esv0000144Dsd0000C045bc04sc03i00'
>>
>> when booting 3.9.8. 3.8.13 has the same issue, 3.6.0 is fine.
> […]
>
> I think oss-compat might interfere here. Given that it was recently
> (2013-06-18) updated, this would explain why only new'ish kernels are
> affected (initramfs not updated for the older ones). Therefore I'd
> suggest to purge oss-compat (simple removal is not sufficient, as the
> modprobe.d/ snippets are dpkg conffiles) for testing - and to file a
> bug[1] against the new version of oss-compat, if you can confirm it
> to be responsible.

Confirm that after purging oss-compat 3.9.8 boot is fine. Please note 
that a yesterday build of 3.6.11 used to work fine too so there's also 
something that changed kernel side.
FYI there was already a bug in debian bug tracker:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=660803#130

thanks a lot,
riccardo
