Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaL1BUB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 20:20:01 -0500
Received: from smtp.infotech.no ([82.134.31.41]:48826 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbaL1BUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 20:20:00 -0500
Message-ID: <549F5AB5.8030803@interlog.com>
Date: Sat, 27 Dec 2014 20:19:49 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>
CC: Tomas Fasth <tomfa@debian.org>, David Sommerseth <davids@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        alexander Motin <mav@FreeBSD.org>
Subject: [ANNOUNCE] ddpt, version 0.95 available
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ddpt is yet another variant of the venerable Unix dd command
line utility. It offers more precise control over a storage
copy and can bypass upper layers to use SCSI commands like READ,
WRITE, WRITE AND VERIFY, WRITE ATOMIC or offloaded copy
mechanisms to move the data. ddpt supports both the Linux
kernel 2.6 and 3 series with ports to FreeBSD, Solaris, and
Windows.

For more information and downloads see:
     http://sg.danny.cz/sg/ddpt.html
     http://sg.danny.cz/sg/ddpt_xcopy_odx.html


Changelog for ddpt-0.95 [20141226] [svn: r307]
   - add oflag=verify[,bytchk] to write using the SCSI
     WRITE AND VERIFY command
   - add job file that holds options; specified either
     freestanding on command line or after --job=
   - show percent completed
   - add DDPT_DEF_BS environment variable
   - add iflag=ff to source 0xff bytes
   - ddptctl: add --hex and --readonly options
   - add atomic flag for WRITE ATOMIC(16) command on OFILE
   - add warning when oflag=strunc copy interrupted
   - win32: ddpt --wscan fixes
   - point svn:externals to rev 620 of sg3_utils
   - upgrade automake to version 1.14.1

Changelog for ddpt-0.94 [20140407] [svn: r277]
...


This package may be built to depend on the shared library
produced by the sg3_utils, version 1.40 package (released
20141113). Alternatively this package can be built to
statically include the code it needs from sg3_utils.

Doug Gilbert
