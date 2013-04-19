Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab3DSGA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:00:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46711 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab3DSGA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:00:57 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130419055813.GA16443@kroah.com>
References: <1366236341-22615-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <20130419055813.GA16443@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode V2
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 18 Apr 2013 23:00:27 -0700
To: Greg KH <gregkh@linuxfoundation.org>,
        "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
CC: matt@console-pimps.org, matthew.garrett@nebula.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, darren.hart@intel.com,
        josh@joshtriplett.org, mingo@kernel.org, tglx@linutronix.de
Message-ID: <bb2db2a1-835f-47d0-830d-0dd3785343a9@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only real use for command line options is to be able to get users to test something during troubleshooting.

Greg KH <gregkh@linuxfoundation.org> wrote:

>On Wed, Apr 17, 2013 at 11:05:41PM +0100, Bryan O'Donoghue wrote:
>> Some EFI BIOS stores BGRT data in the wrong place and some EFI based
>> BIOS also requires mapping of boot code/data when doing
>> efi_enter_virtual_mode.
>> 
>> Current code in efi_enter_virtual_mode maps both EFI_RUNTIME_MEMORY
>and
>> BIOS boot code/data.
>> 
>> This patch gives the option to switch off that behavior - if your
>BIOS
>> has neither BGRT - nor bugs that require mapping of EFI boot
>code/data
>
>No, never add new boot options, no users, or distros, know to set them.
>Isn't there some way we can dynamically determine this instead?
>
>thanks,
>
>greg k-h

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
