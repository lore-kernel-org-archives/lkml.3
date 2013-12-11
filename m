Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab3LKLRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:17:46 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:19638 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3LKLRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:17:42 -0500
X-AuditID: cbfec373-b7ef66d0000001ac-e1-52a849d40b95
Date: Wed, 11 Dec 2013 09:17:28 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.13-rc4] media fixes
Message-id: <20131211091728.53c89d80@samsung.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42I5/e9wkO5VzxVBBi/WM1rMWb+GzeLyrjls
	Fj0btrJaPOp7y+7A4nFixm8Wj8+b5AKYorhsUlJzMstSi/TtErgy2pcsZS9YFVnRedC4gbEl
	vIuRk0NCwERi09Ob7BC2mMSFe+vZuhi5OIQEljBKXLjcxwLhdDNJfJvynhWkikVAVWL52wYW
	EJtNwEjiVWMLWFwEyP784gorSAOzwGJGiY/P14ONFRbQlVh+exdYA6+AoUTvlB9AcQ6gdU4S
	uw9IQYQFJX5MvgdWwiygJbF5WxMrhK0oMW1RA+MERr5ZSMpmISmbhaRsASPzKkbR0uLkguKk
	9FwjveLE3OLSvHS95PzcTYyQwCvewfhig9UhRgEORiUeXonS5UFCrIllxZW5hxglOJiVRHg/
	ua4IEuJNSaysSi3Kjy8qzUktPsTIxMEp1cConSvsvjnVqrrBJt3ngMomsemfExSsNvT+r3r/
	SXfbjONbri59fDVC2eeKS317d7/ylLkNK3v0Hq+2Oqbnzl+yoLFsVc26GuXHt2UfTKrqNHqo
	k5Q9NVzwwaenm86tUQxbbFZ4wmHVj0qeXQevyml+V61kWPza5mVe4q3Wiz96ZzpNYiwO9EpW
	YinOSDTUYi4qTgQAWrnz2xoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBBBHrVB024407

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For a dvb core deadlock fix, a couple videobuf2 fixes an a series of media
driver fixes.

Thank you!
Mauro

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 64c832a4f79542809d6c10b8ec6225ff8b76092e:

  [media] videobuf2-dma-sg: fix possible memory leak (2013-12-10 05:40:57 -0200)

- ----------------------------------------------------------------
Alexey Khoroshilov (1):
      [media] dvb_demux: fix deadlock in dmx_section_feed_release_filter()

Antti Palosaari (4):
      [media] af9035: add [0413:6a05] Leadtek WinFast DTV Dongle Dual
      [media] af9035: fix broken I2C and USB I/O
      [media] af9033: fix broken I2C
      [media] rtl2830: add parent for I2C adapter

Dan Carpenter (2):
      [media] cx231xx: use after free on error path in probe
      [media] af9035: unlock on error in af9035_i2c_master_xfer()

Evgeny Plehov (1):
      [media] cxd2820r_c: fix if_ctl calculation

Felipe Pena (1):
      [media] technisat-usb2: fix typo in variable name

Geert Uytterhoeven (1):
      [media] radio-shark: Mark shark_resume_leds() inline to kill compiler warning

Georg Kaindl (1):
      [media] usbtv: Add support for PAL video source

Geyslan G. Bem (1):
      [media] videobuf2-dma-sg: fix possible memory leak

Hans Verkuil (4):
      [media] bttv: don't setup the controls if there are no video devices
      [media] tef6862/radio-tea5764: actually assign clamp result
      [media] wm8775: fix broken audio routing
      [media] vb2: regression fix: always set length field.

Hans de Goede (2):
      [media] gspca_sunplus: Add new usb-id for 06d6:0041
      [media] radio-shark2: Mark shark_resume_leds() inline to kill compiler warning

Jonathan McCrohan (1):
      [media] media_tree: Fix spelling errors

Laurent Pinchart (1):
      [media] v4l: omap3isp: Don't check for missing get_fmt op on remote subdev

Libin Yang (2):
      [media] marvell-ccic: drop resource free in driver remove
      [media] media: marvell-ccic: use devm to release clk

Michael Krufky (1):
      [media] dvb_demux: clean up whitespace in comments from previous patch (trivial)

Ondrej Zary (1):
      [media] gspca-stk1135: Add delay after configuring clock

Philipp Zabel (1):
      [media] videobuf2: Add support for file access mode flags for DMABUF exporting

Ricardo Ribalda (2):
      [media] em28xx-video: Swap release order to avoid lock nesting
      [media] ths7303: Declare as static a private function

Sachin Kamat (1):
      [media] mt9p031: Include linux/of.h header

Wei Yongjun (2):
      [media] v4l: vsp1: Fix error return code in vsp1_video_init()
      [media] saa7164: fix return value check in saa7164_initdev()

 Documentation/DocBook/media/v4l/vidioc-expbuf.xml |   8 +-
 drivers/media/common/siano/smscoreapi.h           |   4 +-
 drivers/media/common/siano/smsdvb.h               |   2 +-
 drivers/media/dvb-core/dvb_demux.c                |   9 +-
 drivers/media/dvb-frontends/af9033.c              |  12 +-
 drivers/media/dvb-frontends/cxd2820r_c.c          |   2 +-
 drivers/media/dvb-frontends/dib8000.c             |   4 +-
 drivers/media/dvb-frontends/drxk_hard.c           |  18 +--
 drivers/media/dvb-frontends/rtl2830.c             |   1 +
 drivers/media/i2c/adv7183_regs.h                  |   6 +-
 drivers/media/i2c/adv7604.c                       |   2 +-
 drivers/media/i2c/adv7842.c                       |   2 +-
 drivers/media/i2c/ir-kbd-i2c.c                    |   2 +-
 drivers/media/i2c/m5mols/m5mols_controls.c        |   2 +-
 drivers/media/i2c/mt9p031.c                       |   1 +
 drivers/media/i2c/s5c73m3/s5c73m3-core.c          |   2 +-
 drivers/media/i2c/s5c73m3/s5c73m3.h               |   2 +-
 drivers/media/i2c/saa7115.c                       |   2 +-
 drivers/media/i2c/soc_camera/ov5642.c             |   2 +-
 drivers/media/i2c/ths7303.c                       |   3 +-
 drivers/media/i2c/wm8775.c                        |   4 +-
 drivers/media/pci/bt8xx/bttv-driver.c             |   3 +-
 drivers/media/pci/cx18/cx18-driver.h              |   2 +-
 drivers/media/pci/cx23885/cx23885-417.c           |   2 +-
 drivers/media/pci/pluto2/pluto2.c                 |   2 +-
 drivers/media/pci/saa7164/saa7164-core.c          |   4 +-
 drivers/media/platform/coda.c                     |   2 +-
 drivers/media/platform/exynos4-is/fimc-core.c     |   2 +-
 drivers/media/platform/exynos4-is/media-dev.c     |   2 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c  |  46 +-----
 drivers/media/platform/omap3isp/isp.c             |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c        |   7 +-
 drivers/media/platform/s5p-mfc/regs-mfc.h         |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c          |  12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c     |   2 +-
 drivers/media/platform/s5p-tv/mixer.h             |   2 +-
 drivers/media/platform/s5p-tv/mixer_video.c       |   4 +-
 drivers/media/platform/soc_camera/omap1_camera.c  |   2 +-
 drivers/media/platform/vivi.c                     |   4 +-
 drivers/media/platform/vsp1/vsp1_drv.c            |   2 +-
 drivers/media/platform/vsp1/vsp1_video.c          |   4 +-
 drivers/media/radio/radio-shark.c                 |   4 +-
 drivers/media/radio/radio-shark2.c                |   4 +-
 drivers/media/radio/radio-si476x.c                |   4 +-
 drivers/media/radio/radio-tea5764.c               |   2 +-
 drivers/media/radio/tef6862.c                     |   2 +-
 drivers/media/rc/imon.c                           |   2 +-
 drivers/media/rc/redrat3.c                        |   2 +-
 drivers/media/tuners/mt2063.c                     |   4 +-
 drivers/media/tuners/tuner-xc2028-types.h         |   2 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c         |   2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c             |  17 ++-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c           |   4 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c        |   2 +-
 drivers/media/usb/em28xx/em28xx-video.c           |   2 +-
 drivers/media/usb/gspca/gl860/gl860.c             |   2 +-
 drivers/media/usb/gspca/pac207.c                  |   2 +-
 drivers/media/usb/gspca/pac7302.c                 |   2 +-
 drivers/media/usb/gspca/stk1135.c                 |   3 +
 drivers/media/usb/gspca/stv0680.c                 |   2 +-
 drivers/media/usb/gspca/sunplus.c                 |   1 +
 drivers/media/usb/gspca/zc3xx.c                   |   2 +-
 drivers/media/usb/pwc/pwc-if.c                    |   2 +-
 drivers/media/usb/usbtv/usbtv.c                   | 174 +++++++++++++++++-----
 drivers/media/usb/uvc/uvc_video.c                 |   2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c              |   2 +-
 drivers/media/v4l2-core/videobuf2-core.c          |  29 +++-
 drivers/media/v4l2-core/videobuf2-dma-contig.c    |   4 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c        |   3 +-
 include/media/videobuf2-core.h                    |   2 +-
 70 files changed, 293 insertions(+), 190 deletions(-)



- -- 

Cheers,
Mauro
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqEnPAAoJEAhfPr2O5OEVnmsQAIEdz8g88Vaz3W7j1lPHG/d2
pAZ8W8Ql/enddAaozArtr+Rw81X5fP5G4aEY1NPFzHpnJVyqWpWBzgeYo+OqjhPV
KZtT7CQ939YpiTNy1cHxSKt6ogtUYq90ZwKGiQTrM8ulEgQKBZiKQvdVCIrNtqpT
iABHQ7e08SMAY2SmSNi1DXzOMqa3E0BmQJZnYF9ToZv/RndYxi6mZYTgJSeFvuaV
jGV5hSZpeIU0qaVAYu0+XrQe3yCwaBeULqo6122hhdi06SKsgmGsMRnx2xFTW0Zo
lE+k5t+7XbS0jDC5Z4rcXTdzMtqdHJYA02PQs7TZrgC1Wv/2TRIfLdMa0PUojYbq
50ORBpTsOKJAQIIgsHFfT5UWP3/hsFW7XiFV41iTVjlzIlMygpYv9RjXBJm47xx0
0/UbMzicNPmXJP+yeFDYXyuyvye1E+ujjUHX0HmrG7lAL+saZduss3vK6s1wGW0A
LDu1/RUEvH9UyjpZcazWbIafCJOn9sfKQXwfMbl6flPfQrSEkjsRVRK/maCiEXNt
PEkBY4sw5VQGHf5ca1R9/mTErMlDBzVW5yJgPPbfWtt3ssgmJUKS4kRqRYxmqZEF
1gawALsCBiCQ+uoCVzI+m56zxU+KuSnhOtwsxht1J2Ao30EIlNApqf/a9dpw9ZLm
Fz75RsQHRW/byXOWit/y
=WH1O
-----END PGP SIGNATURE-----
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
