Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbaELVIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:08:07 -0400
Received: from we2-f167.wedos.net ([46.28.105.74]:35102 "EHLO
	we2-f167.wedos.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493AbaELVIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:08:04 -0400
Date: Mon, 12 May 2014 23:08:01 +0200
From: Josef Gajdusek <atx@atx.name>
To: Guenter Roeck <linux@roeck-us.net>
Cc: jdelvare@suse.de, lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] hwmon: (emc1403) Various enhancements
Message-ID: <20140512210801.GA7839@dashie>
References: <1399921311-9524-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399921311-9524-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Had to fix wrong variable being printed in show_bit(). After that, everything on the 1412 seems to work fine including alarms.

-	return sprintf(buf, "%d\n", !!(retval & sda->index));
+	return sprintf(buf, "%d\n", !!(val & sda->index));

