Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbaGQVmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:42:45 -0400
Received: from toccata.ens-lyon.org ([140.77.166.68]:48252 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbaGQVmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:42:43 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2014 17:42:43 EDT
Date: Thu, 17 Jul 2014 23:34:58 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: [PATCH,TRIVIAL] Update speakup mailing list address
Message-ID: <20140717213458.GU6456@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The speakup mailing list only works on the linux-speakup.org domain now.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff --git a/MAINTAINERS b/MAINTAINERS
index 61a8f48..bcf5efd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8646,7 +8646,7 @@ M:	William Hubbs <w.d.hubbs@gmail.com>
 M:	Chris Brannon <chris@the-brannons.com>
 M:	Kirk Reiser <kirk@reisers.ca>
 M:	Samuel Thibault <samuel.thibault@ens-lyon.org>
-L:	speakup@braille.uwo.ca
+L:	speakup@linux-speakup.org
 W:	http://www.linux-speakup.org/
 S:	Odd Fixes
 F:	drivers/staging/speakup/
diff --git a/drivers/staging/speakup/TODO b/drivers/staging/speakup/TODO
index c3612e4..3094799 100644
--- a/drivers/staging/speakup/TODO
+++ b/drivers/staging/speakup/TODO
@@ -1,6 +1,6 @@
 Speakup project home:  http://www.linux-speakup.org
 
-Mailing List:  speakup@braille.uwo.ca
+Mailing List:  speakup@linux-speakup.org
 
 Speakup is a kernel based screen review package for the linux operating
 system.  It allows blind users to interact with applications on the
