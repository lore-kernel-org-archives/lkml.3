Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaINAB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 20:01:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38899 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaINABY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 20:01:24 -0400
Date: Sun, 14 Sep 2014 02:01:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Glenn P. Williamson" <glenn.p.williamson@intel.com>
Subject: Re: [PATCH 6/6] x86/efi: introduce EFI_BOOT_SERVICES_WARN
Message-ID: <20140914000130.GC18296@nazgul.tnic>
References: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
 <1410633376-8822-7-git-send-email-ricardo.neri-calderon@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1410633376-8822-7-git-send-email-ricardo.neri-calderon@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 11:36:16AM -0700, Ricardo Neri wrote:
> Being more verbose about this kind of illegal access from the firmware
> increases the likelihood of this kind firmware bugs to be fixed.

I sincerely hope you're right and, more importantly, how do we make sure
those warnings get seen in time for a fix to even be possible..?

-- 
Regards/Gruss,
    Boris.
--
