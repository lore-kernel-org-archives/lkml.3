Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbaICMH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:07:58 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62827 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaICMH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:07:57 -0400
Date: Wed, 3 Sep 2014 13:07:51 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Laszlo Ersek <lersek@redhat.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-ia64@vger.kernel.org, matt.fleming@intel.com, msalter@redhat.com
Subject: Re: [PATCH 3/5] x86: efi: format EFI memory type & attrs with
 efi_md_typeattr_format()
Message-ID: <20140903120751.GC3001@console-pimps.org>
References: <1409532820-5027-1-git-send-email-lersek@redhat.com>
 <1409532820-5027-4-git-send-email-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409532820-5027-4-git-send-email-lersek@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep, at 02:53:38AM, Laszlo Ersek wrote:
> Signed-off-by: Laszlo Ersek <lersek@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

I know this is a straight forward patch in the context of this series,
but you need to include a rationale, so that we know in 6 months, 12
months and 5 years from now why this change made sense.

Something like,

  "Reduce the amount of duplicated code by using the helper function"

would be fine.

-- 
Matt Fleming, Intel Open Source Technology Center
