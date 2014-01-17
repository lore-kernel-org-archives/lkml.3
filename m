Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaAQKx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:53:29 -0500
Received: from mail.wolfsonmicro.com ([87.246.98.25]:45481 "EHLO
	clearswiftegdr.wolfsonmicro.main" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752239AbaAQKxX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:53:23 -0500
X-Greylist: delayed 945 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jan 2014 05:53:23 EST
From: Dimitris Papastamos <Dimitris.Papastamos@Wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>, Daniel Matuschek <daniel@matuschek.net>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 17 Jan 2014 10:35:10 +0000
Subject: RE: [PATCH] ASoC: wm8804: Allow control of master clock divider in
 PLL generation
Thread-Topic: [PATCH] ASoC: wm8804: Allow control of master clock divider in 
    PLL generation
Thread-Index: Ac8THslAguO3RzrmTT+xIrl4XZa6sQAUQLxu
Message-ID: <634C081ADD030F4A829AD09D85144F253611607A04@EXCMB2.wolfsonmicro.main>
References: <alpine.DEB.2.02.1401142030110.23472@parallels-Parallels-Virtual-Platform>,
    <20140117005437.GQ17314@sirena.org.uk>
In-Reply-To: <20140117005437.GQ17314@sirena.org.uk>
Accept-Language: en-US, en-GB
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Charles (or someone else from Wolfson), you commented on previous
> versions of this - are you still OK with it?

Looks good to me.

Privacy & Confidentiality Notice
-------------------------------------------------
This message and any attachments contain privileged and confidential information that is intended solely for the person(s) to whom it is addressed. If you are not an intended recipient you must not: read; copy; distribute; discuss; take any action in or make any reliance upon the contents of this message; nor open or read any attachment. If you have received this message in error, please notify us as soon as possible on the following telephone number and destroy this message including any attachments. Thank you.
-------------------------------------------------
Wolfson Microelectronics plc
Tel: +44 (0)131 272 7000
Fax: +44 (0)131 272 7001
Web: www.wolfsonmicro.com

Registered in Scotland

Company number SC089839

Registered office: 

Westfield House, 26 Westfield Road, Edinburgh, EH11 2QB, UK
