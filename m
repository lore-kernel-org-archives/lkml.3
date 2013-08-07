Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab3HGHoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:44:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54876 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932188Ab3HGHoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:44:17 -0400
Date: Wed, 7 Aug 2013 08:44:10 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
Subject: Re: [PATCH V2 00/17] EFI stub for ARM
Message-ID: <20130807074410.GB2515@console-pimps.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Aug, at 08:44:56PM, Roy Franz wrote:
> This patchset depends (trivially) on a separately submitted bugfix to the
> EFI stub: "correct call to free_pages"
> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=df981edcb9bce00b9c5e4f3cc33f3f98bc9a2394

For those playing at home, this bugfix is now in Linus' tree.

-- 
Matt Fleming, Intel Open Source Technology Center
