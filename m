Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945Ab3D3RbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:31:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:47343 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759233Ab3D3RbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:31:17 -0400
Message-ID: <517FFFCF.4080301@parallels.com>
Date: Tue, 30 Apr 2013 21:30:55 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        CRIU <criu@openvz.org>
Subject: [Announce] Checkpoint-restore tool v0.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ladies and Gentlemen,

I'm glad to announce the 5th release of the checkpoint-restore tool!

This release is mostly about the tool itself. The v3.9 kernel, with which the
new CRIU tool should be used, only contains a couple of bug fixes related to
the C/R project and no new related features. As for the tool itself, there's
a lot of bugs fixed, thanks to new users that come to try the CRIU tool :)

The biggest "new-feature" change so far is about dumping the applications memory.
We have two enhancements in this area:

* memory dumps can be directly sent to the remote node, to speed live migration up;

and

* with the custom crkernel (patches are expected to get merged in Linux-3.10) one
  can track the memory changes, which in turn allows to do e.g. incremental dumps
  or optimize the live migration by sending memory to remote host before freezing
  the application.

The full list of changes is here: http://criu.org/Download/criu/0.5

Have fun!

Thanks,
Pavel
