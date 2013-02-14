Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161027Ab3BNW3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:29:48 -0500
Received: from plane.gmane.org ([80.91.229.3]:45873 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030212Ab3BNW3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:29:46 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Aaron W.  Hsu" <arcfide@sacrideo.us>
Subject: 3.7.x (x > 0) poweroff failure
Date: Thu, 14 Feb 2013 16:02:53 -0500
Organization: Indiana University
Message-ID: <kfjje5$sto$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: c-98-223-194-12.hsd1.in.comcast.net
User-Agent: KNode/4.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hope that this is the right place, but I am using a Samsung Series 7 Gamer 
(i7 + Nvidia) with proprietary graphics drivers. Using 3.7.0 when restarting 
the machine or powering down, things work as expected. However, in 3.7.7 and 
3.7.8 (which is what I have tested so far), the machine does not power down 
afterwards, and when X stops, I do not see the console, just a blinking 
cursor in the upper left hand corner. This has not occurred before in any 
other previous kernel that I have tried, including 3.2.29 and I think 3.6.

Could anyone help direct me to identifying the problem and whether there is 
a problem on my end or if this is some sort of regression in the 3.7.x 
series?

-- 
Aaron W. Hsu | arcfide@sacrideo.us | http://www.sacrideo.us
לֵ֤ב חֲכָמִים֙ בְּבֵ֣ית אֵ֔בֶל וְלֵ֥ב כְּסִילִ֖ים בְּבֵ֥ית שִׂמְחָֽה׃


