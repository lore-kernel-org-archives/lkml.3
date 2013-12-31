Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab3LaHai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 02:30:38 -0500
Received: from mailuogwhop.emc.com ([168.159.213.141]:26239 "EHLO
	mailuogwhop.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3LaHag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 02:30:36 -0500
X-Greylist: delayed 1545 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Dec 2013 02:30:36 EST
X-DKIM: OpenDKIM Filter v2.4.3 mailuogwprd03.lss.emc.com rBV74fuT018821
X-DKIM: OpenDKIM Filter v2.4.3 mailuogwprd03.lss.emc.com rBV74fuT018821
From: "Peng, Tao" <tao.peng@emc.com>
To: Jim Davis <jim.epost@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "andreas.dilger@intel.com" <andreas.dilger@intel.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: RE: randconfig build error with 3.13-rc6, in
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c
Thread-Topic: randconfig build error with 3.13-rc6, in
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c
Thread-Index: AQHPBYDnxpQZjcPG6U2L0tGE8cNHU5pt4Pjg
Date: Tue, 31 Dec 2013 07:04:28 +0000
Message-ID: <1882637210201641A747464075FFC6491D224C04@MX101CL02.corp.emc.com>
References: <CA+r1Zhi0_qi6ror96v03Lv1bfmeK_d-XLv6LTemR+RSpDz6K=Q@mail.gmail.com>
In-Reply-To: <CA+r1Zhi0_qi6ror96v03Lv1bfmeK_d-XLv6LTemR+RSpDz6K=Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.250.132.84]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Sentrion-Hostname: mailusrhubprd51.lss.emc.com
X-RSA-Classifications: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Jim Davis [mailto:jim.epost@gmail.com]
>Sent: Tuesday, December 31, 2013 1:02 AM
>To: linux-kernel@vger.kernel.org; Greg Kroah-Hartman;
>andreas.dilger@intel.com; Peng, Tao; sachin.kamat@linaro.org;
>devel@driverdev.osuosl.org
>Subject: randconfig build error with 3.13-rc6, in
>drivers/staging/lustre/lustre/lmv/lproc_lmv.c
>
>Building with the attached random configuration file,
>
>drivers/staging/lustre/lustre/lmv/lproc_lmv.c: In function
>‘lprocfs_lmv_init_vars’:
>drivers/staging/lustre/lustre/lmv/lproc_lmv.c:232:26: error:
>‘lprocfs_lmv_module _vars’ undeclared (first use in this function)
>  lvars->module_vars    = lprocfs_lmv_module_vars;
>                          ^
This is the !CONFIG_PROC_FS error and has been fixed in Greg's staging tree by commit 2c185ffa2 and 9d2834dd.

Thanks,
Tao
