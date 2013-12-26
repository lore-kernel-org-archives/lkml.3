Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3LZBxC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 20:53:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab3LZBxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 20:53:00 -0500
Date: Thu, 26 Dec 2013 09:53:08 +0800
From: Dave Young <dyoung@redhat.com>
To: matt@console-pimps.org, hpa@zytor.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: split efi systab in sysfs
Message-ID: <20131226015308.GA3750@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Matt and Peter

Currently /sys/firmware/efi/systab contains multi-lines for efi systab
entries. As previous discussion with Greg, this is not a good in sysfs.
I wonder if there's other users for this file except kexec-tools.

If kexec-tools is the only user, maybe I can split it as several files.
In kexec-tools just use /sys/firmware/efi/"$entry_name" and if $entry_name
does not exist then switch to old systab file. 

Thanks
Dave
