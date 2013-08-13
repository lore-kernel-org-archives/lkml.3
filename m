Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab3HMN5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:57:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757549Ab3HMN5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:57:23 -0400
Message-ID: <1376402209.27484.14.camel@t520.redhat.com>
Subject: Re: [PATCH 03/16] Rename memory allocation/free functions
From: Mark Salter <msalter@redhat.com>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
Date: Tue, 13 Aug 2013 09:56:49 -0400
In-Reply-To: <1376090777-20090-4-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	 <1376090777-20090-4-git-send-email-roy.franz@linaro.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> Rename them to be more similar, as low_free() could be used to free
> memory allocated by both high_alloc() and low_alloc().
> high_alloc() -> efi_high_alloc()
> low_alloc()  -> efi_low_alloc()
> low_free()   -> efi_free()
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---

Tested on arm64.

Acked-by: Mark Salter <msalter@redhat.com>


