Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaLQI4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:56:31 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59360 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaLQI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:56:29 -0500
Date: Wed, 17 Dec 2014 09:56:26 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Changes for v3.19-rc1
Message-ID: <20141217085625.GA3929@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm.git tags/pwm/for-3.19-rc1

for you to fetch changes up to 39e046f2c1dd0742976d7ee6e464744cf2122f41:

  pwm: atmel-hlcdc: add at91sam9x5 and sama5d3 errata handling (2014-12-04 11:32:36 +0100)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Changes for v3.19-rc1

There are two new drivers, one for the BCM2835 (Raspberry Pi) and one
used in conjunction with the LCD controller on various Atmel SoCs. The
Samsung PWM driver can now be built for 64-bit ARM (Exynos7).

A couple of fixes have been applied to the FTM PWM driver and system
sleep support was added.

----------------------------------------------------------------
Abhilash Kesavan (1):
      pwm: samsung: Allow Samsung PWM driver to be enabled on Exynos7

Bart Tanghe (1):
      pwm: Add BCM2835 PWM driver

Boris BREZILLON (1):
      pwm: atmel-hlcdc: add at91sam9x5 and sama5d3 errata handling

Boris Brezillon (2):
      pwm: add support for atmel-hlcdc-pwm device
      pwm: add DT bindings documentation for atmel-hlcdc-pwm driver

Xiubo Li (3):
      pwm: ftm: Correctly track usage count
      pwm: ftm: Add regmap rbtree type cache support
      pwm: ftm: Add Power Management support for FTM PWM

 .../devicetree/bindings/pwm/atmel-hlcdc-pwm.txt    |  29 ++
 .../devicetree/bindings/pwm/pwm-bcm2835.txt        |  30 +++
 drivers/pwm/Kconfig                                |  22 +-
 drivers/pwm/Makefile                               |   2 +
 drivers/pwm/pwm-atmel-hlcdc.c                      | 299 +++++++++++++++++++++
 drivers/pwm/pwm-bcm2835.c                          | 205 ++++++++++++++
 drivers/pwm/pwm-fsl-ftm.c                          |  64 ++++-
 7 files changed, 646 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt
 create mode 100644 drivers/pwm/pwm-atmel-hlcdc.c
 create mode 100644 drivers/pwm/pwm-bcm2835.c

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUkUU5AAoJEN0jrNd/PrOhuZMP/1qxoG+ZABiBXTZ+W1fPXiwr
by88S2wrcqAnCW0rpKRr0Q+7+W5Ht2WRoTbLHFq5QC4EJSkCBH0VLTE3onURWeHR
ycJ+LdxSpuE+S2epljfyR2iN4Akv+oucq/E9Qsc1el6UmEe4qWhsdoyvLCpTO0IO
aIBJxy54l//OZ02gGwIgHcahv1FdsxBpzJU7NNVd9CnRF5hKnb65FNd9neXOjfHg
Kt6jzk/PKtnwgFkPShVau0+4ib6zazJ2pXrcljz0DE7LEJosFc4GpBvP+WSsWtOd
sMnEnOoOMIgPfUu3Jxty0tcyfj8KL5znQ6ltNDcp0IbX8d+qFwc7uVeObwKbrtV7
OkPOIGHfPeWkCfwkg2LqpKns6lOW1ZdSSa65d+HBw18l5QmQlAplQNlS9t3mqTSv
WHELUUflMjQzRNy7uDAR/aadP+fkoQ+XosLcHGhUjbyxBYq00Vf6l4JM0JFR0isF
K8eN7js/iZ3YmB3J2PJt9MEdNcBEwRS3amuhkyH3bw4j481zhvQK7C8dSlLMCmrV
Yq2ylMinqeoNgkFlc+50CQeh0GDVf4Ld07HvPRkN13Veu+j8XOq7UPDGLydh++v3
+Pbwaux8ElV7Zurz6hd9uFVTDcbBel9V9eYWhFeAJDA7l3q7wn5f0qsJdp+ANoYk
RnHRNrTKAyuJzg1j4WfC
=be6T
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
