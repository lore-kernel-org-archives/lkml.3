Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab3HMN5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:57:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab3HMN5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:57:37 -0400
Message-ID: <1376402228.27484.17.camel@t520.redhat.com>
Subject: Re: [PATCH 06/16] Enforce minimum alignment of 1 page on
 allocations. The efi_high_alloc() and efi_low_alloc() functions use the
 EFI_ALLOCATE_ADDRESS option to the EFI function allocate_pages(), which
 requires a minimum of page alignment, and rejects all other requests.
From: Mark Salter <msalter@redhat.com>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
Date: Tue, 13 Aug 2013 09:57:08 -0400
In-Reply-To: <1376090777-20090-7-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	 <1376090777-20090-7-git-send-email-roy.franz@linaro.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> The existing code could fail to allocate depending
> on allocation size, as although repeated allocation
> attempts were made, none were guaranteed to be page
> aligned.
> 
> 
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---

Tested on arm64.

Acked-by: Mark Salter <msalter@redhat.com>


