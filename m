Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaIXPob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:44:31 -0400
Received: from sauhun.de ([89.238.76.85]:41074 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbaIXPo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:44:28 -0400
Date: Wed, 24 Sep 2014 17:44:58 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean Delvare <jdelvare@suse.de>,
        "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: Re: [PATCH] i2c: move acpi code back into the core
Message-ID: <20140924154457.GB1283@katana>
References: <1411420006-4713-1-git-send-email-wsa@the-dreams.de>
 <5420CEC9.1030400@intel.com>
 <20140923053951.GA1411@katana>
 <54211C96.3030608@intel.com>
 <542139E6.2030806@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <542139E6.2030806@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Hi Wolfram:
> The patch passed through the following 110 configure build test in the
> 0-day build test system.

Thanks, but my tree gets checked automatically anyhow. What I'd need is
functional tests because I don't have hardware to test.


--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIub5AAoJEBQN5MwUoCm2vkEP/3JCSxcOmGYXL9OOCFPDLk2h
JsdsiTtfjMdb7Yrr6gM3OsK9Dp2N/06kOX+7c7SkvHe9mQW4OyfW3LYzHcC4Qmks
VpIOT3RpWAbffGGpPXmcLizRHMP+irhhFhpNxTANKNHkCRmBEgSsAQuwjGnoJi8Q
Riiz1udc1AviIdg0bpAINijwIeMliKN2H9dPSDRIOqebS+zEI0e86lPGcMa4ZkhV
F2VDRF1B9jAg5kXJGi7XYtYovfBTPDhzPQcrSLzYwuADNGmBlNcazrlzB79Qo2ZH
5T+wkvGpfyV1oletDaWmxanT1wDcwQIiaPUy7djPu30WRm0rqpto630uWhDgkIn6
UJdeFd4QMdyzCxwhqR1LmfIoz7lST8B2JpzZvDfLB2of2oW9YKaTI3ZwQ2SxiYnA
B/QEW/QJJVtKF4GFc7tBu75M+EdWy1hEHO3nmS+iljToaSx72Br8TR4J/6FUDwkh
q4kOQfVr33ovYXAamVMqYFjbvDZzV9xV28+LvN3h8Gp/3B4nSmg9dVfE2USBUE2O
ZNvbMINdyCHYYiG16Cz2xXEFtMbYOQk9xyVBCcPAhG8+FRKVIAHT/fTSk1J+ysrT
mEZLRzK3MY+oz1l6YZTcjX4rkd+s9tx3kVMQ5UV+FLY7PzQHR651ffnDlPphZ8kX
PKpZartgjc3dakoDos0U
=NC45
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
