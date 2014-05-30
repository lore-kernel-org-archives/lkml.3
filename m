Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaE3Hw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:52:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60937 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbaE3Hw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:52:27 -0400
Date: Fri, 30 May 2014 09:52:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: matt.fleming@intel.com, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, vgoyal@redhat.com
Subject: Re: [PATCH]x86 efi: do not export efi runtime map in case old map
Message-ID: <20140530075219.GC28131@pd.tnic>
References: <20140530032010.GA29906@dhcp-16-198.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140530032010.GA29906@dhcp-16-198.nay.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 11:20:10AM +0800, Dave Young wrote:
> 
> For ioremapped efi memory aka old_map the virt addresses are not persistant
> across kexec reboot. kexec-tools will read the runtime maps from sysfs then
> pass them to 2nd kernel and assuming kexec efi boot is ok. This will cause
> kexec boot failure.
> 
> To address this issue do not export runtime maps in case efi old_map so
> userspace can use no efi boot instead.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
