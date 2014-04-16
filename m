Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaDPJGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:06:14 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38080 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbaDPJGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:06:10 -0400
Date: Wed, 16 Apr 2014 10:06:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Michael Brunner <mibru@gmx.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Chris Healy <chealy@imsco-us.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH] mfd: Add sysfs attributes for Kontron PLD firmware
 revision
Message-ID: <20140416090604.GB4754@lee--X1>
References: <20140408082106.2bb49571@hyperion>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140408082106.2bb49571@hyperion>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds attributes to the Kontron PLD driver to allow
> applications to retrieve firmware information.
> Additionally the format has been changed to conform with the
> representation in other Kontron software.
> 
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/mfd/kempld-core.c  | 127 +++++++++++++++++++++++++++++++++++++--------
>  include/linux/mfd/kempld.h |   4 ++
>  2 files changed, 110 insertions(+), 21 deletions(-)

Looks mostly sane and has Guenter's support so, applied thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
