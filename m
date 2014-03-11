Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaCKBHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 21:07:33 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63003 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaCKBHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 21:07:30 -0400
Date: Mon, 10 Mar 2014 18:07:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 6/8] mfd: lpc_ich: Change Avoton to iTCO v3
Message-ID: <20140311010726.GF32676@roeck-us.net>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
 <1394487298-14459-6-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394487298-14459-6-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 04:34:56PM -0500, Peter Tyser wrote:
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

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
