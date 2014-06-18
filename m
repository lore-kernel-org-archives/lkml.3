Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbaFROPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:15:46 -0400
Received: from mail-wi0-f193.google.com ([209.85.212.193]:53066 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaFROPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:15:44 -0400
Date: Wed, 18 Jun 2014 15:15:41 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH v5 0/7] xen: Add EFI support
Message-ID: <20140618141541.GM24049@console-pimps.org>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun, at 07:00:16PM, Daniel Kiper wrote:
> Hey,
> 
> This patch series adds EFI support for Xen dom0 guests.
> It is based on Jan Beulich and Tang Liang work. I was
> trying to take into account all previous comments,
> however, if I missed something sorry for that.
> 
> Daniel
> 
>  arch/x86/kernel/setup.c          |    4 +-
>  arch/x86/platform/efi/efi.c      |   77 ++++++++++-------
>  arch/x86/xen/enlighten.c         |   24 ++++++
>  drivers/firmware/efi/efi.c       |   26 +++---
>  drivers/xen/Kconfig              |    4 +
>  drivers/xen/Makefile             |    3 +
>  drivers/xen/efi.c                |  374 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h              |    3 +-
>  include/xen/interface/platform.h |  123 +++++++++++++++++++++++++++
>  9 files changed, 595 insertions(+), 43 deletions(-)

FWIW I'm much happier with this version than v4. There's nothing that
jumps out at me as being obviously wrong. Just a few minor cleanups
needed.

Which tree is this intended to go through? I'm more than happy to take
it through the EFI tree, particularly since it touches
include/linux/efi.h and drivers/firmware/efi/efi.c which is the core EFI
interface for all platforms.

But if it's going through the Xen tree or something, I can supply my
Acked-by's (once the aforementioned minor cleanups are taken care of).

-- 
Matt Fleming, Intel Open Source Technology Center
