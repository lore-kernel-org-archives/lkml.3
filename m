Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaDLAag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 20:30:36 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40318 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaDLAae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 20:30:34 -0400
From: Silvio Fricke <silvio.fricke@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Silvio Fricke <silvio.fricke@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH v3 0/3] remove wrong cast of gfp_t flags
Date: Sat, 12 Apr 2014 02:30:23 +0200
Message-Id: <cover.1397260702.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <20140410201606.GA12335@kroah.com>
References: <20140410201606.GA12335@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > thanks for your review.
> > Attached second version of this series.
> 
> I don't understand what the [WIP] marking is.  Please just resend these
> as "real" patches if you feel they are ready to be merged.  If we have
> issues with them, we will be sure to let you know :)

I removed it. 


Bye,
Silvio


v3: * no 'WIP'! Don't do that!

v2: * signed-off and message are not the same address



Silvio Fricke (3):
  staging: vt6655: removed incorrect casting in wpactl.c
  staging: vt6655: removed incorrect casting in ioctl.c
  staging: vt6655: removed incorrect casting in iwctl.c

 drivers/staging/vt6655/ioctl.c  | 6 ++++--
 drivers/staging/vt6655/iwctl.c  | 2 +-
 drivers/staging/vt6655/wpactl.c | 6 +++---
 3 files changed, 8 insertions(+), 6 deletions(-)

-- 
1.9.2

