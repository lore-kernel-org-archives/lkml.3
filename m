Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbbAURbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:31:39 -0500
Received: from mout.gmx.net ([212.227.15.19]:61370 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbbAURbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:31:31 -0500
MIME-Version: 1.0
Message-ID: <trinity-e585b2ff-5707-41eb-be40-241e3d5a2e16-1421861470660@3capp-gmx-bs36>
From: "Peter Huewe" <PeterHuewe@gmx.de>
To: "Jim Davis" <jim.epost@gmail.com>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, tpmdd@selhorst.net,
        tpmdd-devel@lists.sourceforge.net,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Subject: Aw: randconfig build error with next-20150121, in
 drivers/char/tpm/tpm_tis.c
Content-Type: text/plain; charset=UTF-8
Date: Wed, 21 Jan 2015 18:31:10 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <CA+r1ZhiCiLc5yDABJPYR7-Jz=M+XE5RvGzTKc=zvb1M9qRjosw@mail.gmail.com>
References: <CA+r1ZhiCiLc5yDABJPYR7-Jz=M+XE5RvGzTKc=zvb1M9qRjosw@mail.gmail.com>
Content-Transfer-Encoding: 8BIT
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:bmV5DK5kaMiWucXo0CyrklPK//eGWGbz98/MPlCixOc
 jJSM88XdlcLRBlPeFp4V3ZD/owszZkscV5WoB1dP0nS0heWIhr
 GP83H4yQHZ1Ge4G+EHq5EXcfYePWStLOyQFZP0ZtIA3G7pveEV
 O4RxpEzLI+OExm6DSHOg/sDhtf5bbZiwh2HtQG2sSeKjFYmtva
 Ef96JktNApBfU8lZudvzSGIi2JOY2AQb4ID/7ukFT4y2Vfepfe
 B9aKWjkdh3SKWPcSefUprGrYjGCsW+5eXTOKeBii+gn7MWUFIV 6zo7iU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Thanks for reporting.
 

>drivers/char/tpm/tpm_tis.c: In function ‘tpm_tis_pnp_init’:
>drivers/char/tpm/tpm_tis.c:912:45: error: invalid type argument of
>‘->’ (have ‘int’)
>acpi_dev_handle = pnp_acpi_device(pnp_dev)->handle;
>^
>make[3]: *** [drivers/char/tpm/tpm_tis.o] Error 1
I'll look into it.


sorry sorry.

Peter
