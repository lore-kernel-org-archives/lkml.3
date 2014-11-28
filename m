Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaK1B2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 20:28:21 -0500
Received: from smtp.infotech.no ([82.134.31.41]:36917 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaK1B2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 20:28:17 -0500
Message-ID: <5477CF9A.5060003@interlog.com>
Date: Thu, 27 Nov 2014 20:27:54 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        David Sommerseth <davids@redhat.com>, Hannes Reinecke <hare@suse.de>
Subject: [ANNOUNCE] lsscsi version 0.28 released
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsscsi is a command line utility that probes sysfs in Linux
2.6 and 3 series kernels in order to list information about
SCSI devices and SCSI hosts. The default format is one device
(e.g. disk) per line. Other storage devices that use the SCSI
subsystem such as SATA and USB keys are also listed.

Version 0.28 is available at:
     http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
plus a Download and Build information section containing
tarballs, rpm and deb packages.

ChangeLog:
Version 0.28 2014/09/30 [svn: r120]
   - fix handling of scsi_level 0 (no compliance)
   - add SRP transport identifier
   - add --unit option for LU identifier (>= lk 3.15)
   - add (S)ATA transport identifier (>= lk 3.15)
   - make USB transport ids more consistent
   - fix FC transport id missing comma
   - add pdt strings for security manager and zbc
   - upgrade automake to version 1.14.1

Version 0.27 2013/05/08 [svn: r111]
...


Doug Gilbert
