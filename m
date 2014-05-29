Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350AbaE2V3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:29:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbaE2V3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:29:15 -0400
Date: Thu, 29 May 2014 18:28:12 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Scott Wood <scottwood@freescale.com>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-pcmcia@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PPC: 8xx: update MAINTAINERS entry
Message-ID: <20140529212812.GA9000@amt.cnet>
References: <1400916970.31526.78.camel@x220>
 <1401387624.6603.161.camel@snotra.buserror.net>
 <1401388744.25908.16.camel@x220>
 <1401390275.25908.24.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401390275.25908.24.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not involved in 8xx activities for years, update MAINTAINERS
to reflect it.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c47d268..ed7b606 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5349,7 +5349,6 @@ F:	arch/powerpc/*/*/*virtex*
 
 LINUX FOR POWERPC EMBEDDED PPC8XX
 M:	Vitaly Bordug <vitb@kernel.crashing.org>
-M:	Marcelo Tosatti <marcelo@kvack.org>
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@lists.ozlabs.org
 S:	Maintained
