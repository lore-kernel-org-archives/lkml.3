Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab3LCARp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 19:17:45 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:57554 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3LCARo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 19:17:44 -0500
Date: Mon, 2 Dec 2013 16:17:41 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, "'Jean Delvare'" <khali@linux-fr.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH 10/39] hwmon: remove DEFINE_PCI_DEVICE_TABLE macro
Message-ID: <20131203001741.GA18237@roeck-us.net>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <001f01ceefb3$b1968820$14c39860$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001f01ceefb3$b1968820$14c39860$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 08:10:29AM +0900, Jingoo Han wrote:
> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>
