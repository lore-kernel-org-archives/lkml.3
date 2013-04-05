Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3DEFI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:08:56 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49083 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3DEFIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:08:55 -0400
X-Originating-Ip: 216.16.235.2
Date: Fri, 5 Apr 2013 00:56:28 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: linux-kernel@vger.kernel.org
Subject: libata: can't set force= on subdevice
Message-ID: <20130405045628.GA27991@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Using kernel 3.2.x (Debian Wheezy) and when setting libata.force= kernel
command line parameters, there seems to be a conflict with the '.'.

For example, with the following boot argument:

	libata.force=ata1.0:udma/44

I get:

	libata: Unknown parameter '0:udma/44'
	libata: Unknown parameter '0:udma/44'
	libata: Unknown parameter '0:udma/44'
	libata: Unknown parameter '0:udma/44'

Which I think is from kernel/params.c, not drivers/ata/libata-core.c.

- Chris

