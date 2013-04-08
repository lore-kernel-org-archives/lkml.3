Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935148Ab3DHLgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:36:13 -0400
Received: from mail-lb0-f196.google.com ([209.85.217.196]:41684 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935012Ab3DHLgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <CALRtADNMPv4MkJQAxF1y+iK9F2tGAiXsRrveazho5C6KSb4gcQ@mail.gmail.com>
References: <CALRtADNMPv4MkJQAxF1y+iK9F2tGAiXsRrveazho5C6KSb4gcQ@mail.gmail.com>
Date: Mon, 8 Apr 2013 14:36:10 +0300
Message-ID: <CALRtADMNGcJaArziv6be3tDZsi9uyWA=3OD+Vi4mpzY99TMJ-A@mail.gmail.com>
Subject: Linux 3.9 input documentation patch
From: "Florin9(doi)" <florin9doi@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a patch for linux 3.9.

--- a/Documentation/input/alps.txt 2013-04-01 18:02:56.230177850 +0000
+++ b/Documentation/input/alps.txt 2013-04-01 18:03:15.010177850 +0000
@@ -225,18 +225,18 @@ packets.  This appears to only be used b

 For single-touch, the 6-byte packet format is:

- byte 0:    1    1    0    0    1    0    0    0
+ byte 0:    1    1    0    0    1    p   mt    0
  byte 1:    0   x6   x5   x4   x3   x2   x1   x0
  byte 2:    0   y6   y5   y4   y3   y2   y1   y0
  byte 3:    0    M    R    L    1    m    r    l
- byte 4:   y10  y9   y8   y7  x10   x9   x8   x7
+ byte 4:  y10   y9   y8   y7  x10   x9   x8   x7
  byte 5:    0   z6   z5   z4   z3   z2   z1   z0

 For mt, the format is:

- byte 0:    1    1    1    n3   1   n2   n1   x24
- byte 1:    1   y7   y6    y5  y4   y3   y2    y1
- byte 2:    ?   x2   x1   y12 y11  y10   y9    y8
- byte 3:    0  x23  x22   x21 x20  x19  x18   x17
- byte 4:    0   x9   x8    x7  x6   x5   x4    x3
- byte 5:    0  x16  x15   x14 x13  x12  x11   x10
\ No newline at end of file
+ byte 0:    1    1    1   f2    1   f1   f0  x22
+ byte 1:   ox   y6   y5   y4   y3   y2   y1   y0
+ byte 2:   oy   x1   x0  y11  y10   y9   y8   y7
+ byte 3:    0  x21  x20  x19    1  x18  x17  x16
+ byte 4:    0   x8   x7   x6   x5   x4   x3   x2
+ byte 5:    0  x15  x14  x13  x12  x11  x10   x9
\ No newline at end of file
