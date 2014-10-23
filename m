Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaJWLNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:13:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbaJWLNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:13:09 -0400
Message-Id: <20141023110924.936986783@ett.arch.suse.de>
User-Agent: quilt/0.48-16.4
Date: Thu, 23 Oct 2014 13:09:24 +0200
From: trenn@suse.de
To: minyard@acm.org
Cc: martin.wilck@ts.fujitsu.com, trenn@suse.de, linux-kernel@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
Subject: [patch 0/3] Compile ipmi_devintf into ipmi_msghandler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the ipmi_devintf to be a module, but it will automatically
be compiled in if ipmi_msghandler is set.
This will remove the overhead of an additional module (unneeded memory and 
sysfs files and additional autoloading of the userspace interface
(which was broken) is not needed anymore.

Would be great to see this queued up in an upstream git tree, scheduled
for inclusion for Linus' tree.

Thanks!

     Thomas

-- 
Thomas Renninger,SUSE LINUX GmbH; Maxfeldstrasse 5; D-90409 Nuernberg; Zi. 2.3-10,+49-911-740 53-675,,serv=loki,mail=imap,type=real <trenn@arch.suse.de>
