Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab3CBXUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 18:20:17 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50398 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3CBXUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 18:20:16 -0500
Date: Sat, 2 Mar 2013 15:16:26 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: twl4030-madc: Add support for raw value in
 twl4030_madc_conversion
Message-ID: <20130302231626.GA23826@lizard.sbx05280.losalca.wayport.net>
References: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 11:56:49PM +0100, Pali Rohár wrote:
> Driver twl4030-madc has hardcoded channel types (10 - battery current,
> 1 - battery temperature) and also conversation data in variable
> twl4030_divider_ratios. These hardcoded channels are incorrect for
> Nokia RX-51 board (where is channel 0 - battery temperature).
> 
> For Nokia RX-51 there is rx51_battery power_supply driver which reporting
> battery information via twl4030_madc_conversion. But this driver needs
> raw values (not converted via some hardcoded functions). So this patch
> adding new parameter "raw" to struct twl4030_madc_request which tell
> twl4030-madc driver to not convert values, but rather return raw.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

It looks good to me; glancing around, I don't see any better way to do it.
So,

Reviewed-by: Anton Vorontsov <anton@enomsg.org>

Thanks!

Anton
