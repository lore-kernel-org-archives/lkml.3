Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab3HGNJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:09:50 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39389 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932909Ab3HGNJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:09:47 -0400
Date: Wed, 7 Aug 2013 14:09:44 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
Subject: Re: [PATCH 10/17] Renames in handle_cmdline_files() to complete
 generalization.
Message-ID: <20130807130944.GE2515@console-pimps.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
 <1375847113-24884-11-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375847113-24884-11-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Aug, at 08:45:06PM, Roy Franz wrote:
> Rename variables to be not initrd specific, as now the function
> loads arbitrary files.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  drivers/firmware/efi/efi-stub-helper.c |   92 ++++++++++++++++----------------
>  1 file changed, 46 insertions(+), 46 deletions(-)

This looks nice, thanks.

-- 
Matt Fleming, Intel Open Source Technology Center
