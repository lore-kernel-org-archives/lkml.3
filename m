Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbaIKOxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:53:40 -0400
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:47779 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbaIKOxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:53:37 -0400
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2014 10:53:37 EDT
Date: Thu, 11 Sep 2014 23:45:10 +0900
To: linux-kernel@vger.kernel.org
Subject: /dev/root changes with 3.17-rc
Message-ID: <20140911144510.GK22037@auth.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

(please cc)

I am not sure whether this is a kernel bug, but:
- booting with 3.16 I get
	/ mounted on /dev/sda6
- booting with 3.17-rc* I get
	/ mounted on /dev/root

The later case disturbs grub (cannot find root device) as there
is no /dev/root.

I normally to make oldconfig when compiling a new kernel, all of 
the above are self-compiled.

Thanks

Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
------------------------------------------------------------------------
