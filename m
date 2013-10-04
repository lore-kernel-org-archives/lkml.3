Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3JDRdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:33:17 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:52484 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3JDRdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:33:14 -0400
Date: Fri, 4 Oct 2013 19:33:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, hpa@zytor.com, msalter@redhat.com,
        patches@linaro.org
Subject: Re: [PATCH] Remove redundant and incorrect memset()
Message-ID: <20131004173310.GA15689@gmail.com>
References: <20131003131054.GB27835@gmail.com>
 <1380902566-30867-1-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380902566-30867-1-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roy Franz <roy.franz@linaro.org> wrote:

> Remove a redundant memset() call from efi_relocate_kernel() that
> was clearing memory that would be used by BSS in non-compressed
> images loaded with this function.  This clear was redundant with
> the clearing done in the image itself, and also implemented incorrectly
> with a 0 length.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> Acked-by: Mark Salter <msalter@redhat.com>

Note the title:

   [PATCH] Remove redundant and incorrect memset()

if it's both redundant *and* incorrect then the other memset() must be 
incorrect too and must be removed as well ;-)

I suspect you wanted the title to say:

   [PATCH] Remove redundant memset()

?

Thanks,

	Ingo
