Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab3LKT36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:29:58 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:57536 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3LKT35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:29:57 -0500
Date: Wed, 11 Dec 2013 11:29:54 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: =?iso-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: HIH-6130: Support I2C bus drivers without
 I2C_FUNC_SMBUS_QUICK
Message-ID: <20131211192954.GA21751@roeck-us.net>
References: <1386760273-7703-1-git-send-email-jose.goncalves@inov.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386760273-7703-1-git-send-email-jose.goncalves@inov.pt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 11:11:13AM +0000, José Miguel Gonçalves wrote:
> Some I2C bus drivers do not allow zero-length data transfers which are
> required to start a measurement with the HIH6130/1 sensor. Nevertheless,
> we can overcome this limitation by writing a zero dummy byte. This byte
> is ignored by the sensor and was verified to be working with the OMAP
> I2C bus driver in a BeagleBone board.
> 
> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>

Applied, after simplifying write_length initialization a bit.

Should this go to -stable ?

Guenter
