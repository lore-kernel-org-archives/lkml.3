Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab3KKLHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:07:25 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:54966 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752980Ab3KKLHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:07:18 -0500
Date: Mon, 11 Nov 2013 11:07:01 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Madper Xie <cxie@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [BUG]: DELL XPS 8500 become a brick after fill too many entries
 to nvram.
Message-ID: <20131111110701.GE22636@console-pimps.org>
References: <87fvr3h3b9.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvr3h3b9.fsf@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov, at 02:15:22PM, Madper Xie wrote:
> Howdy all,
>   For now we ensure at least ~5kb free space. But my dell xps still
>   become a brick after I add too many entries to my nvram. So maybe 5kb
>   is not safe enough. and 5kb is just aginst Samsung's laptop.
>   So should we enlarge EFI_MIN_RESERVE?

Urgh.............

Thanks for the report. Could you provide some more details?

 - Is your machine definitely bricked?
 - Exactly which Dell machine is this?
 - What were you doing to cause your machine to not boot? Using
   efibootmgr?
 - Please send your .config
 - Have you reported this to any BIOS engineers to confirm the cause of
   the bricking?
 - Have you got a dmesg from the machine before it broke?

-- 
Matt Fleming, Intel Open Source Technology Center
