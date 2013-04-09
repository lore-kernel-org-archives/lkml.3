Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937065Ab3DIJfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:35:53 -0400
Received: from sauhun.de ([89.238.76.85]:60340 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932892Ab3DIJft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:35:49 -0400
Date: Tue, 9 Apr 2013 11:35:45 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] The AT24 driver only uses page size of 1 byte if no
 platform data is provided to the probe function. When this eeprom is
 detected via open firmware tree in powerpc architecture the correct chip
 type is given to the probe function. So the driver can extract the page size
 for optimal performance out of this chip type.
Message-ID: <20130409093545.GG3624@the-dreams.de>
References: <1363614733-1179-1-git-send-email-Sergey.Gerasimov@astrosoft-development.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363614733-1179-1-git-send-email-Sergey.Gerasimov@astrosoft-development.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 05:52:13PM +0400, Sergey Gerasimov wrote:
> Signed-off-by: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>

NAK. Page size may differ across vendors, so we can't hardcode values in
that table. There is a "pagesize" property for devicetree.

And please make sure you don't write the whole description in the
subject.

