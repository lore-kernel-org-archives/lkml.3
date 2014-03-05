Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbaCETrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:47:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40056 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbaCETrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:47:35 -0500
Date: Wed, 5 Mar 2014 20:47:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 08/11] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20140305194729.GF28317@pd.tnic>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-9-git-send-email-vgoyal@redhat.com>
 <20140227213629.GP18191@pd.tnic>
 <20140228163134.GG28744@redhat.com>
 <20140305163722.GC28317@pd.tnic>
 <20140305184010.GC1740@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140305184010.GC1740@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 01:40:10PM -0500, Vivek Goyal wrote:
> I thought Dave passed relevant information on bootparams and some in
> cmdline (I have not looked at details). Once the EFI support is in,
> kernel implementaion should do the same thing as kexec-tools is doing
> to pass EFI mapping information to second kernel.

Right, he reads the runtime map from sysfs:

Documentation/ABI/testing/sysfs-firmware-efi-runtime-map

How exactly he prepares it with kexec-tools I don't remember anymore - I
just skimmed over that part at the time.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
