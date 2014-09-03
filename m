Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbaICMyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:54:47 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:32930 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619AbaICMqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:17 -0400
Date: Wed, 3 Sep 2014 13:46:13 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Laszlo Ersek <lersek@redhat.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-ia64@vger.kernel.org, matt.fleming@intel.com, msalter@redhat.com
Subject: Re: [PATCH 2/5] efi: introduce efi_md_typeattr_format()
Message-ID: <20140903124613.GD3001@console-pimps.org>
References: <1409532820-5027-1-git-send-email-lersek@redhat.com>
 <1409532820-5027-3-git-send-email-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409532820-5027-3-git-send-email-lersek@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep, at 02:53:37AM, Laszlo Ersek wrote:
> +char * __init efi_md_typeattr_format(char *buf, size_t size,
> +				     const efi_memory_desc_t *md)
> +{
> +	char *pos;
> +	int type_len;
> +	register u64 attr;

You can delete the 'register' keyword, since the compiler is free to
ignore it (and will do so).

Rest of the patch looks good.

-- 
Matt Fleming, Intel Open Source Technology Center
