Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaKDXUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:20:30 -0500
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:50589 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaKDXU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:20:29 -0500
Date: Wed, 5 Nov 2014 08:20:27 +0900
To: linux-kernel@vger.kernel.org
Subject: khugepaged / firefox going wild in 3.18-rc
Message-ID: <20141104232027.GO13232@auth.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

(please Cc)

since 3.18-rc started, regularly, but unpredictably, firefox
(Debian iceweasel) goes completely boom to 100% CPU, and there
is also a kernel task khugepaged doing the same.

I need to kill firefox, or better the X session to get it back to normal.

THe logs don't show any strange output

top's top process:

27021 norbert   20   0 1351536 449868  88788 R 100.4  5.6   4:46.16 iceweasel   
   35 root      39  19       0      0      0 R 100.0  0.0   2:41.10 khugepaged  

Switching back to 3.17 does Not* exhibit the same behaviour.

Is this a bug in Firefox/Iceweasel, or is there something luring in the
kernel.


All the best

Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
------------------------------------------------------------------------
