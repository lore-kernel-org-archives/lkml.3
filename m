Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbaFRN4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:56:23 -0400
Received: from mail-we0-f195.google.com ([74.125.82.195]:51999 "EHLO
	mail-we0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbaFRN4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:56:21 -0400
Date: Wed, 18 Jun 2014 14:56:18 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH v5 5/7] arch/x86: Replace plain strings with constants
Message-ID: <20140618135618.GI24049@console-pimps.org>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-6-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402678823-24589-6-git-send-email-daniel.kiper@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun, at 07:00:21PM, Daniel Kiper wrote:
> v5 - suggestions/fixes:
>    - do not change indentation
>      (suggested by Matt Fleming).
> 
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> ---
>  arch/x86/kernel/setup.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Looks good, but it's customary to have at least one line after the patch
title. Even something as trivial as,

  "We've got constants, so let's use them instead of hard-coded values."

-- 
Matt Fleming, Intel Open Source Technology Center
