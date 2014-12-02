Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaLBJWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:22:22 -0500
Received: from hofr.at ([212.69.189.236]:53608 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaLBJWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:22:18 -0500
Date: Tue, 2 Dec 2014 10:14:10 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] documentation of _shipped and offset header files
Message-ID: <20141202091410.GA13909@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset cleanup includes documentation updates for _shipped files, 
offset header files as well as some directly related change proposals 
in Kbuild and CodingStyle.

This proposed patch set describes the intent and use of _shipped files
and offset header files as well as a minor update on the handling
of external module dependencies.

- an additional clause to Documentation/CodingStyle for _shipped files
- a description of _shipped in Documentation/kbuild/makefiles.txt
- documentation of offset header files
- change to scripts/Makefile.lib to restrict _shipped to .c .h and .S files
  and a special (historic) .incl_shipped case
- fix wording in Documentation/kbuild/modules.txt on _shipped files

thx!
hofrat
