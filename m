Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab3CYMBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:01:53 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:54972 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756602Ab3CYMBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:01:52 -0400
Message-ID: <1364212909.1390.289.camel@x61.thuisdomein>
Subject: Re: [uclinux-dist-devel] [PATCH] Blackfin: bf537: rename
 "CONFIG_ADT7310" and friends
From: Paul Bolle <pebolle@tiscali.nl>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 13:01:49 +0100
In-Reply-To: <51503B16.1050108@metafoo.de>
References: <1364211831.1390.285.camel@x61.thuisdomein>
	 <51503B16.1050108@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 12:01:49.0976 (UTC) FILETIME=[88372180:01CE2950]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-25 at 12:55 +0100, Lars-Peter Clausen wrote:
> Thanks for the patch. Unfortunately this has already changed again for 3.10
> since we replaced the IIO adt7410/adt7310 driver with a hwmon driver. So the
> new config name is CONFIG_SENSORS_ADT7310.

That leaves v3.8 and v3.9 with a (minor?) problem, doesn't it? If that's
correct, can't something along the lines of my patch be added to v3.9
(and then trivially backported to v3.8)?


Paul Bolle

