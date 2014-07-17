Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbaGQHFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:05:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:14066 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbaGQHFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:05:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,676,1400050800"; 
   d="asc'?scan'208";a="544633267"
Date: Thu, 17 Jul 2014 02:34:38 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        toshi.kani@hp.com, imammedo@redhat.com, bp@alien8.de,
        huawei.libin@huawei.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        umgwanakikbuti@gmail.com, peterz@infradead.org
Subject: Re: [PATCH v2] x86,cpu-hotplug: assign same CPU number to readded CPU
Message-ID: <20140717063438.GA2311@gchen.bj.intel.com>
References: <53C62AAF.7060509@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <53C62AAF.7060509@jp.fujitsu.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Jul 16, 2014 at 04:33:03PM +0900, Yasuaki Ishimatsu wrote:
[...]
> + * Bind ACPI ID to Logical CPU number
           ^^^^
           APIC

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTx25+AAoJEI01n1+kOSLH5mMP+weieRzFDzNswOi1/VVSeib4
buzsGpqBRvW51ZjY4UQp/0xLmpgshvt9WFyI2rtRq9j/YCKSRKA/SszgKfLWbNb9
+F3MqCXJJZEZ3W6yLc8SUAViRDGZn5YLN+FjhTgmLFIVICk4mBcciMPYBOiy6zzC
5TFZTnvymI2YAeCvECWlN6kJJHK5waP9PDVSnXTBkiqCKzj9gRBdtQ7mRSYduhAB
nOPKjxGlMax4Fy2uaOQRxPtfK8PishCxEi4Es/YnsXsdwmQM5psDo//ROLzBNxl4
oX2vgdfB5k/dKc7bSyQtZ5p3ClUBJwqWKegPB7+giXQPPVmmgkdEdxpcWg/DG4sm
Y2qM5ghnILLJgrZA/ioGIQgN0eAetP73Vmrvz+JzDCpFvr6Ck+GlFfj/2wcvmEGS
kk7EjloJPdu0dByCRQUTBGxeiPfYw4kem43F3vqBHEwLdBVcGHEsOpcf2hAZG1ki
/mI2QmGersu3V6Ltjvp9T/CtI7YSDJ0ZMgUrRw/2PldebHMho2ZDRDCgBQqJtwMm
NIs/O4Ve/mkJscPPbaYmM8wgbDO/l8c84zQSdAkw/b2XfD24B3M5vJJ9Vk1LMqX1
KyYw5ujtAQz4oV7Rt/Y+ziP9JYqNQXFJUS1Lh1tejO2+ob1ZNNqTLt/w6VBrmzpP
t5/1KfRCBSIQOhe/nuID
=DG+w
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
