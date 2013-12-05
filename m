Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab3LELaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:30:21 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:53008 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753698Ab3LELaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:30:20 -0500
Date: Thu, 5 Dec 2013 11:30:16 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/3] Introduce FW_INFO* functions and messages
Message-ID: <20131205113016.GB3823@console-pimps.org>
References: <1385997579-22240-1-git-send-email-prarit@redhat.com>
 <1385997579-22240-2-git-send-email-prarit@redhat.com>
 <20131203132120.6a7ab2cd7cc99720712cbe6a@linux-foundation.org>
 <201312041922.59181.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312041922.59181.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Dec, at 07:22:57PM, Arnd Bergmann wrote:
> The other part I noticed about this particular patchset is that it's
> not really "firmware" as such, but specifically PC wiht ACPI that
> gets covered here. So rather than generalizing the code, another
> option would be to narrow down the scope and make it
> acpi_{warn,info,dbg} instead.

Making this specific to ACPI runs the risk of people introducing a
multitude of new logging functions for every subsystem, e.g.
efi_{warn,info,dbg}.

FWIW, I'd be interested in using something like this patch series to
properly log EFI implementation bugs. The logging for EFI is currently
done fairly haphazardly.

-- 
Matt Fleming, Intel Open Source Technology Center
