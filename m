Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaJANez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:34:55 -0400
Received: from hofr.at ([212.69.189.236]:47524 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaJANey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:34:54 -0400
Date: Wed, 1 Oct 2014 15:34:52 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Randy Dunlap <rdunlap@infradead.org>, Michal Marek <mmarek@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] documentation of _shipped
Message-ID: <20141001133452.GA5560@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


documentation of _shipped

This proposed patch set describes the intent and use of _shipped files
in the kernel build system. The three parts are:

- a description of _shipped in Documentation/kbuild/makefiles 
- an additional clause to Documentation/CodingStule for _shipped files
- change to scripts/Makefile.lib to restrict _shipped to .c .h and .S files

Patches are against 3.17.0-rc6
