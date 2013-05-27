Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab3E0Vov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 17:44:51 -0400
Received: from mout.gmx.net ([212.227.17.22]:56570 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab3E0Vou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 17:44:50 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/1Z6wC76n1G2LLBDxSlQJNvMYbEPqIqmGF+Cdm3e
	a7Ak1Bt615auAW
Message-ID: <51A3D3CD.1010305@gmx.de>
Date: Mon, 27 May 2013 23:44:45 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130516 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 3.10.0-rcX: s2ram'ed system cannot be wake up by an external USB
 keyboard
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do have a ThinkPad T420 with external VGA monitor + USB keyboard.

Till 3.9.4 I just can press the enter button at the external keyboard to
wake up a system. With 3.10.rcX however this won#t work any more.
However short) open and close the LID works.

Known issue ? (Because bisecting this can't be automated ...)

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
