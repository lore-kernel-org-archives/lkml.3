Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab3CINOU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 08:14:20 -0500
Received: from lnx141.hrz.tu-darmstadt.de ([130.83.156.236]:56169 "EHLO
	lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932197Ab3CINOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 08:14:19 -0500
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Mar 2013 08:14:19 EST
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20795.13390.998299.670195@elektron.ikp.physik.tu-darmstadt.de>
Date: Sat, 9 Mar 2013 14:08:30 +0100
To: linux-kernel@vger.kernel.org
Subject: Power Regression with TP T520 and  3.8.2
X-Mailer: VM 7.19 under Emacs 21.3.1
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2013.3.9.125720
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

while with older kernels, I could go down to a power drain of 8 Watt at
minimum display intensity, booting to Opensuse 3.8.2-2-vanilla and other
recent kernels, I can no longer get below 16 Watt.

Has anybody seen something similar? Any hints?

Thanks
-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
