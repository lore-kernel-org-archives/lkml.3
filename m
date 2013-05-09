Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093Ab3EIEJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 00:09:17 -0400
Received: from smtp.infotech.no ([82.134.31.41]:51360 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab3EIEJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 00:09:15 -0400
Message-ID: <518B2120.9040607@interlog.com>
Date: Thu, 09 May 2013 00:08:00 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Dan_Hor?= =?ISO-8859-1?Q?=E1k?= 
	<dhorak@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>
Subject: [ANNOUNCE] lsscsi version 0.27 released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsscsi is a command line utility that probes sysfs in Linux
2.6 and 3 series kernels in order to list information about
SCSI devices and SCSI hosts. Both a compact format which is
one line per device and a "classic" format (like the output
of 'cat /proc/scsi/scsi') are supported.

Version 0.27 is available at:
     http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
plus a Download and Build information section containing
tarballs, rpm and deb packages.


ChangeLog:
Version 0.27 2013/05/08 [svn: r111]
   - rework buffer handling for systems with many disks
   - add --lunhex option for displaying LUNs in hex
   - accept LUNs from sysfs as large as a 64 bit unsigned
     decimal number (largest was signed 32 bit decimal)
   - accept LSSCSI_LUNHEX_OPT environment variable
   - add --scsi_id option for /dev/disk/by-id/scsi*

Version 0.26 2012/01/31 [svn: r97]
....

Doug Gilbert
