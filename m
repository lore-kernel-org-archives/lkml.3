Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812Ab3HGV4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:56:04 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41961 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933521Ab3HGV4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:56:00 -0400
Date: Wed, 7 Aug 2013 22:55:54 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Dave Martin <dave.martin@arm.com>
Subject: Re: [PATCH 03/17] Add system pointer argument to shared EFI stub
 related functions so they no longer use global system table pointer as they
 did when part of eboot.c.
Message-ID: <20130807215554.GI2515@console-pimps.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
 <1375847113-24884-4-git-send-email-roy.franz@linaro.org>
 <20130807130851.GC2515@console-pimps.org>
 <CAFECyb8NbZ=hrAGyoV-UPUhh-Jst6ZVRk9RUQj_Kb1qq_xuUAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFECyb8NbZ=hrAGyoV-UPUhh-Jst6ZVRk9RUQj_Kb1qq_xuUAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Aug, at 10:10:54AM, Roy Franz wrote:
> I went this way since the shared code is in a separate file - I really
> didn't like using a global variable as part of the interface to
> the shared code.  This has the nice side benefit of allowing the ARM
> stub to not use any global variables, so we don't have to do
> any GOT fixups to relocate the code - it is position independent if we
> don't use global variables.

OK, that would be a win. Please include this rationale in the patch.

-- 
Matt Fleming, Intel Open Source Technology Center
