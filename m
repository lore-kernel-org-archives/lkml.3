Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaILMga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:36:30 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:51536 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953AbaILMg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:36:29 -0400
Message-ID: <1410525387.31130.44.camel@x220>
Subject: [PATCH] [TRIVIAL] Remove MN10300_PROC_MN2WS0038
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Richard Weinberger <richard@nod.at>, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 14:36:27 +0200
In-Reply-To: <1409910355.5546.157.camel@x220>
References: <1391971686-9517-19-git-send-email-richard@nod.at>
	 <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1098.1392044308@warthog.procyon.org.uk> <1397553194.1985.23.camel@x220>
	 <1403084538.1984.76.camel@x220> <1409910355.5546.157.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2014 12:36:27.0407 (UTC) FILETIME=[2BDFF1F0:01CFCE86]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-05 at 11:45 +0200, Paul Bolle wrote:
> No surprises here: not part of v3.17-rc3 nor next-20140904. Do you have
> suggestions for an alternative route?

You know what: let's try trivial! And I've added my Signed-off-by in an
obvious attempt to inflate the count of commits with my name attached.

Jiri, could you please put this in trivial queue?

Thanks,


Paul Bolle
------->8--------
From: Richard Weinberger <richard@nod.at>

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/mn10300/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index a648de1b1096..4434b54e1d87 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -181,7 +181,7 @@ endmenu
 config SMP
 	bool "Symmetric multi-processing support"
 	default y
-	depends on MN10300_PROC_MN2WS0038 || MN10300_PROC_MN2WS0050
+	depends on MN10300_PROC_MN2WS0050
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, say N. If you have a system with more
-- 
1.9.3

