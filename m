Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaCKBIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 21:08:14 -0400
Received: from mail-pd0-f193.google.com ([209.85.192.193]:46607 "EHLO
	mail-pd0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbaCKBIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 21:08:09 -0400
Date: Mon, 10 Mar 2014 18:08:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 7/8] mfd: lpc_ich: Add support for NM10 GPIO
Message-ID: <20140311010806.GG32676@roeck-us.net>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
 <1394487298-14459-7-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394487298-14459-7-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 04:34:57PM -0500, Peter Tyser wrote:
> The NM10's GPIO is compatible with ICH v7 GPIO.
> 
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Tested-by: Dan Weinlader <danw@vs-networks.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: James Ralston <james.d.ralston@intel.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
