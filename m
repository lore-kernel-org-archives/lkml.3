Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3JaUmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 16:42:33 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:54343 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3JaUmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 16:42:32 -0400
MIME-Version: 1.0
In-Reply-To: <20131031093718.GA9453@gmail.com>
References: <52700d2920076a466d@agluck-desk.sc.intel.com>
	<20131031093718.GA9453@gmail.com>
Date: Thu, 31 Oct 2013 13:42:31 -0700
Message-ID: <CA+8MBb+UJNusv_gb4ys6UEuFA_OYxoBRgNKeHF0G6jxkEFJ1Nw@mail.gmail.com>
Subject: Re: [GIT PULL] Move drivers/acpi/apei/cper.c to drivers/firmware/efi/
From: Tony Luck <tony.luck@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 2:37 AM, Ingo Molnar <mingo@kernel.org> wrote:
> Hm, it's not very well tested:
>
>   drivers/firmware/efi/Kconfig:41: syntax error
>   drivers/firmware/efi/Kconfig:40: unknown option "defbool"

Gah!  That's exactly what I found yesterday ... and fixed the typo to change
to "def_bool" ... and *tried* to "git --amend" before I tagged and
sent the pull.

To mash up Yoda and Mythbusters:
  There is no try - only fail

Just re-did it ... and according to gitweb the new tag is there and points
at the new commit with the "def_bool" version.

Please try the pull again (same tag name as before) ... so the stuff below
is right except new pull will:

 ... fetch changes up to 7ea6c6c15ee16f4c7f5eeaa62f77e696f85ae0d1:

Sorry for the inconvenience

-Tony
>
> * Luck, Tony <tony.luck@intel.com> wrote:
>
>> The following changes since commit 56507694de3453076d73e0e9813349586ee67e59:
>>
>>   EDAC, GHES: Update ghes error record info (2013-10-23 10:11:00 -0700)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-move-cper
>>
>> for you to fetch changes up to c57a801195153e111bcd712680a718cf101b6d1f:
>>
>>   Move cper.c from drivers/acpi/apei to drivers/firmware/efi (2013-10-29 09:23:38 -0700)
>>
>> ----------------------------------------------------------------
>> cper.c implements UEFI Appendix N "Common Platform Error Record"
>> handling. Move it to drivers/firmware/efi/cper.c to reflect this
>> heritage.
>>
>> ----------------------------------------------------------------
>> Tony Luck (1):
>>       Move cper.c from drivers/acpi/apei to drivers/firmware/efi
>>
>>  drivers/acpi/Kconfig                       | 4 +++-
>>  drivers/acpi/apei/Kconfig                  | 2 ++
>>  drivers/acpi/apei/Makefile                 | 2 +-
>>  drivers/firmware/efi/Kconfig               | 3 +++
>>  drivers/firmware/efi/Makefile              | 1 +
>>  drivers/{acpi/apei => firmware/efi}/cper.c | 0
>>  6 files changed, 10 insertions(+), 2 deletions(-)
>>  rename drivers/{acpi/apei => firmware/efi}/cper.c (100%)
