Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750882AbaABKLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:11:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42659 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaABKLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:11:30 -0500
Date: Thu, 2 Jan 2014 13:10:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ilija Hadzic <ihadzic@research.bell-labs.com>
Cc: Valentina Manea <valentina.manea.m@gmail.com>, anthony.foiani@gmail.com,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, ly80toro@cip.cs.fau.de,
        linux-kernel@vger.kernel.org, andy.grover@gmail.com,
        alan@linux.intel.com
Subject: Re: [PATCH] staging: usbip: add support for viewing imported devices
Message-ID: <20140102101051.GA28413@mwanda>
References: <1387821655-24720-1-git-send-email-valentina.manea.m@gmail.com>
 <Pine.GSO.4.64.1312231312580.15803@umail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.1312231312580.15803@umail>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-Werror=unused-parameter is stupid.  Better to turn it off instead of
ugly work arounds.

regards,
dan carpenter

