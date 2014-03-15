Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161019AbaCOUFA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 16:05:00 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:34020 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161001AbaCOUE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 16:04:58 -0400
Date: Sat, 15 Mar 2014 21:04:56 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 6/8] mfd: lpc_ich: Change Avoton to iTCO v3
Message-ID: <20140315200456.GE14815@spo001.leaseweb.com>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com> <1394487298-14459-6-git-send-email-ptyser@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394487298-14459-6-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> The register layout of the Avoton is compatible with the iTCO v3
> register layout.
> 
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Tested-by: Rajat Jain <rajatjain@juniper.net>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: James Ralston <james.d.ralston@intel.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: linux-watchdog@vger.kernel.org
> ---
>  drivers/mfd/lpc_ich.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 

Acked-by: Wim Van Sebroeck <wim@iguana.be>

Kind regards,
Wim.

