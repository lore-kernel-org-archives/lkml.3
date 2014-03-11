Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaCKA75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:59:57 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37615 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaCKA74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:59:56 -0400
Date: Mon, 10 Mar 2014 17:59:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 3/8] mfd: lpc_ich: Remove lpc_ich_cfg struct use
Message-ID: <20140311005953.GC32676@roeck-us.net>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
 <1394487298-14459-3-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394487298-14459-3-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 04:34:53PM -0500, Peter Tyser wrote:
> Future chipsets will use different register layouts that don't map
> cleanly to the lpc_ich_cfg fields.  Remove the lpc_ich_cfg struct and
> add explicit fields to the higher level lpc_ich_priv structure.
> 
> This change should have no functional impact.
> 
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Tested-by: Rajat Jain <rajatjain@juniper.net>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: James Ralston <james.d.ralston@intel.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
