Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab3FZOkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:40:49 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56818 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303Ab3FZOkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:40:46 -0400
Date: Wed, 26 Jun 2013 15:40:42 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, hpa@linux.intel.com, tglx@linutronix.de
Subject: Re: [PATCH 2/4] x86: efi: break efi_lookup_mapped_addr out to
 generic code
Message-ID: <20130626144042.GS22026@console-pimps.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-3-git-send-email-leif.lindholm@linaro.org>
 <20130626133217.GO22026@console-pimps.org>
 <20130626141130.GC9078@rocoto.smurfnet.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626141130.GC9078@rocoto.smurfnet.nu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun, at 04:11:30PM, Leif Lindholm wrote:
> Sure.
> Would you be happy for me to start moving the other things mentioned
> (config table parsing, common debug printout, global structs) in there too?

Super, super happy.

-- 
Matt Fleming, Intel Open Source Technology Center
