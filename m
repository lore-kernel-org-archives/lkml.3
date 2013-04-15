Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3DOKAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:00:16 -0400
Received: from plane.gmane.org ([80.91.229.3]:42961 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab3DOKAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:00:14 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "lkml@tigusoft.pl" <lkml@tigusoft.pl>
Subject: Very poor latency when using hard drive (raid1)
Date: Mon, 15 Apr 2013 11:59:59 +0200
Organization: tigusoft.pl
Message-ID: <kkgj31$jc6$1@ger.gmane.org>
Reply-To: lkml@tigusoft.pl
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: bolobolo1.torservers.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 2 hard drives (normal, magnetic) in software raid 1
on 3.2.41 kernel.

When I write into them e.g. using dd from /dev/zero to a local file
(ext4 on default settings), running 2 dd at once (writing two files) it
starves all other programs that try to use the disk.

Running ls on any directory on same disk (same fs btw), takes over half
minute to execute, same for any other disk touching action.

Did anyone seen such problem, where too look, what to test?

What could solve it (other then ionice on applications that I expect to
use hard drive)?


