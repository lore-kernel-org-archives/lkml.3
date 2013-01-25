Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab3AYUTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:19:38 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:19338 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3AYUTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:19:37 -0500
Date: Fri, 25 Jan 2013 21:19:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>
Subject: Re: [PATCH 3/3] i2c-i801: SMBus patch for Intel Avoton DeviceIDs
Message-ID: <20130125211922.39bb71ef@endymion.delvare>
In-Reply-To: <1359144661-3528-1-git-send-email-seth.heasley@intel.com>
References: <1359144661-3528-1-git-send-email-seth.heasley@intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013 12:11:01 -0800, Seth Heasley wrote:
> This patch adds the PCU SMBus DeviceID for the Intel Avoton SOC.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>

Reviewed-by: Jean Delvare <khali@linux-fr.org>

> ---
>  Documentation/i2c/busses/i2c-i801 |    1 +
>  drivers/i2c/busses/Kconfig        |    1 +
>  drivers/i2c/busses/i2c-i801.c     |    3 +++
>  3 files changed, 5 insertions(+), 0 deletions(-)

-- 
Jean Delvare
