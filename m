Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405Ab3GaWNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:13:32 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47944 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab3GaWNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:13:31 -0400
Date: Wed, 31 Jul 2013 15:13:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: Re: [PATCH] hwmon: (max6697) fix MAX6581 ideality
Message-ID: <20130731221324.GB29618@roeck-us.net>
References: <1375218874-10882-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375218874-10882-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 05:14:34PM -0400, Vivien Didelot wrote:
> Without this patch, the values for ideality (register 0x4b) and ideality
> selection mask (register 0x4c) are inverted.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Good catch. Applied.

Thanks,
Guenter
