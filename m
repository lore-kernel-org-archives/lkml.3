Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaBSK01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:26:27 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:52413 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbaBSK0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:26:25 -0500
Message-ID: <1392805582.27558.30.camel@x220>
Subject: scripts/get_maintainer.pl: http addresses in MAINTAINER's L: line
From: Paul Bolle <pebolle@tiscali.nl>
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 19 Feb 2014 11:26:22 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Feb 2014 10:26:23.0234 (UTC) FILETIME=[098AE620:01CF2D5D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Joe,

(You two touched this script the most, it seems.)

The MAINTAINERS entry for the "TARGET SUBSYSTEM" uses an http address
for one of its L: lines. The "DC395x SCSI driver" does that too. This
shows up as a useless line in the output of scripts/get_maintainer.pl:
    [...]
     (open list:TARGET SUBSYSTEM)
    [...]

Should another test be added to get_maintainer.pl (which is already over
2000 lines long) or should these two entries be converted to "W:"?


Paul Bolle

