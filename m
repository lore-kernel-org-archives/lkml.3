Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbaHGOXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:23:54 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59595 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaHGOXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:23:52 -0400
Date: Thu, 7 Aug 2014 16:23:46 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, ajitpal.singh@st.com
Subject: Re: [PATCH v2 06/11] pwm: sti: Add new driver for ST's PWM IP
Message-ID: <20140807142344.GA11095@ulmo.nvidia.com>
References: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
 <1405348412-7352-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <1405348412-7352-7-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 14, 2014 at 03:33:27PM +0100, Lee Jones wrote:
[...]
> +static int sti_pwm_probe(struct platform_device *pdev)
> +{
[...]
> +	pc->clk = of_clk_get_by_name(np, "pwm");

This didn't compile because the np variable isn't declared. It was easy
to fix up, so I did, but please be more careful next time that the
patches you submit at least compile (preferably without sparse warnings
of which I also fixed up a couple).

Thierry

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT44vwAAoJEN0jrNd/PrOhpFoQAJwqmsIk7noDjJTpYqAUBCpp
xYopvk4EtZfEe9Fl8yzDTr8oRC1wyijP72PmdKUO1D33gPqgiNqPn33ky4OwOK/U
pMqjlUioZPU8dVWjVewy3f/XCRFtedkIw9mu9v50i2grORY18yYVmuas/O2RoRG/
/dJVZyP0GqrcaKfstpiTuxtDpMeucpdMFd1ppRvA5LBmdSvdun6qaTcqXrfUwbVN
QzNxTB/QkOlezA5qSvKHkIPRigDrpb+zCNmfWj8pcG2pDz6vKwHukAZ1/rXf+Ww1
laPwQ3/Cke/IYx78+wdUtbBbooTRZcZBqdMLpAxHPqnGQUOb23CLXNdDkGjBFPUk
MmOpUob3vg4cF8vzuivwDc4K/TMwU6Zmxf/nSeUDCca6uD7BjyWQS21nRkwOz7ob
Fobr4n16kSt9jEgAe1g1VowrKI4mla4t2ngRJXH2V5rzeoO9rpGrbi67a04bV/MV
RMMv6Gr2iuslR6+re8uALuX0JLxBqdT02i9pibWkCuJJLoMRMqkS2F1LJ1CfyAq2
ucs9UErC57Jfh4m3UYn9c9meeUF7K+5oyPuuRvTA1csVLnStC5WEb7+PEJzuHLBA
22KzbCGXUg+Fq8FZS8VWaW5kCVsSsg0A3nvSYcFkPiBlV4MTz9HJysNtkIAMUn6x
OeT8S/WhocGLv7BHYjCv
=0kUt
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
