Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab3AOPJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:09:12 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:53628 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756994Ab3AOPJK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:09:10 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ido Yariv <ido@wizery.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@steicsson.com>
Date: Tue, 15 Jan 2013 16:08:57 +0100
Subject: RE: [RFCv2 04/11] remoteproc: Add state RPROC_LOADED
Thread-Topic: [RFCv2 04/11] remoteproc: Add state RPROC_LOADED
Thread-Index: Ac3fIPs/QYVLNu9ETma9ZO2CMwQvGwUDd7kw
Message-ID: <81C3A93C17462B4BBD7E272753C1057924588EE05A@EXDCVYMBSTM005.EQ1STM.local>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-5-git-send-email-sjur.brandeland@stericsson.com>
 <20121221021454.GB28692@WorkStation.localnet>
In-Reply-To: <20121221021454.GB28692@WorkStation.localnet>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Add state RPROC_LOADED as firmware loading and startup will be
> > different states.
> >
> > Signed-off-by: Sjur Brændeland <sjur.brandeland@steicsson.com>
> 
> The rproc_state holds the state of the remote processor and it will
> still be offline even when the FW is loaded, so I'm not sure if a new
> state should be added.

In the new set of patches I am using this state in order to know if I need
to reload the firmware before starting the device.

So I need this state in order to differentiate between a boot/reboot and
rproc_shutdown, rproc_boot sequence. In the latter case I need to reload
the firmware in order to initialize static variables and resource table in
device memory.

Regards,
Sjur
