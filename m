Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3GKAgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:36:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab3GKAgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:36:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: oliver+list@schinagl.nl, linux@roeck-us.net, khali@linux-fr.org
Subject: [PATCH v2 0/7] Driver core and sysfs changes for attribute groups
Date: Wed, 10 Jul 2013 17:35:58 -0700
Message-Id: <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's the second iteration of the patchset to add better attribute
group support to the driver core and sysfs.

I've tested these (shocker!) and everything works fine with them (I'm
sending this from Linus's latest kernel with these 7 on top of it.)

I'd like to send these to Linus for 3.11 unless someone objects.

Oliver, please use this series instead of the last one, it has fixes
that Guenter pointed out that would have crashed your box at boot.

changes from v2:
	- actually boots
	- 7th patch added properly
	- added BUS_ATTR, CLASS_ATTR, and DRIVER_ATTR RW and RO macros
	  to help with converting code to use attributes properly.

thanks,

greg k-h

