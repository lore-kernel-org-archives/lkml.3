Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaJ0Tyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:54:37 -0400
Received: from hofr.at ([212.69.189.236]:54347 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbaJ0Tyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:54:35 -0400
Date: Mon, 27 Oct 2014 20:54:34 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Randy Dunlap <rdunlap@infradead.org>, Michal Marek <mmarek@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4 v2] documentation of _shipped and offset header files
Message-ID: <20141027195434.GF10079@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


documentation of _shipped and offset header files

This proposed patch set describes the intent and use of _shipped files
and offset header files in the kernel build system. The three parts are:

- a description of _shipped in Documentation/kbuild/makefiles
- an additional clause to Documentation/CodingStule for _shipped files
- change to scripts/Makefile.lib to restrict _shipped to .c .h and .S files
  and a special (historic) .incl_shipped case
- documentation of offset header files

thx!
hofrat
