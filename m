Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3JICMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 22:12:05 -0400
Received: from lug-owl.de ([195.71.106.12]:60616 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234Ab3JICMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 22:12:01 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2013 22:12:00 EDT
Date: Wed, 9 Oct 2013 04:01:48 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: gma500_gfx: Black VGA display with Intel D2500CC board
Message-ID: <20131009020147.GE24222@lug-owl.de>
Mail-Followup-To: Alan Cox <alan@linux.intel.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lb0e7rgc7IsuDeGj"
Content-Disposition: inline
X-Operating-System: Linux mail 3.2.0-4-686-pae 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear
 warfare test the bombastical terror of flooding the spy listeners explosion
 sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare
 test the bombastical terror of flooding the spy listeners explosion sex
 drugs and rock'n'roll
X-message-flag: Please send plain text messages only. Do not send HTML
 emails. Thank you. 
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lb0e7rgc7IsuDeGj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I'll try an up-to-date kernel tomorrow, but with 3.10.x running, I
thought the usual fixes for black screens should be included.

  The board features a VGA as well as a DVI connector, VGA is
connected. No LVDS, no DisplayPort. With DRM debugging enabled, I get
this:

[    0.000000] Linux version 3.10-3-amd64 (debian-kernel@lists.debian.org) =
(gcc version 4.7.3 (Debian 4.7.3-7) ) #1 SMP Debian 3.10.11-1 (2013-09-10)
[...]
[   15.714564] [drm] Initialized drm 1.1.0 20060810
[   28.544053] [drm:drm_pci_init],=20
[   28.544088] [drm:drm_get_pci_dev],=20
[   28.544279] [drm:drm_get_minor],=20
[   28.544482] [drm:drm_get_minor], new minor assigned 64
[   28.544487] [drm:drm_get_minor],=20
[   28.544632] [drm:drm_get_minor], new minor assigned 0
[   28.544657] gma500 0000:00:02.0: setting latency timer to 64
[   28.544782] [drm:psb_intel_opregion_setup], OpRegion detected at 0xcef92=
018
[   28.544797] [drm:psb_intel_opregion_setup], Public ACPI methods supported
[   28.544801] [drm:psb_intel_opregion_setup], ASLE supported
[   28.544838] gma500 0000:00:02.0: irq 49 for MSI/MSI-X
[   28.544862] [drm:psb_intel_init_bios], Using VBT from OpRegion: $VBT CED=
ARVIEW      d
[   28.544871] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1080" 0=
 144000 1920 2016 2080 2176 1080 1088 1092 1100 0x8 0xa
[   28.544881] [drm:parse_sdvo_device_mapping], No SDVO device info is foun=
d in VBT
[   28.544888] [drm:parse_edp], EDP timing in vbt t1_t3 2000 t8 10 t9 2000 =
t10 500 t11_t12 5000
[   28.544894] [drm:parse_edp], VBT reports EDP: Lane_count 1, Lane_rate 6,=
 Bpp 24
[   28.544899] [drm:parse_edp], VBT reports EDP: VSwing  0, Preemph 0
[   28.560830] acpi device:29: registered as cooling_device0
[   28.561260] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: n=
o)
[   28.561428] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/LNXVIDEO:00/input/input1
[   28.561515] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   28.561553] [drm] No driver support for vblank timestamp query.
[   28.561591] [drm:drm_irq_install], irq=3D49
[   28.562110] [drm:drm_sysfs_connector_add], adding "VGA-1" to sysfs
[   28.562160] [drm:drm_sysfs_hotplug_event], generating hotplug event
[   28.623667] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adap=
ter intel drm LVDSDDC_C
[   28.623678] [drm:drm_sysfs_connector_add], adding "LVDS-1" to sysfs
[   28.623731] [drm:drm_sysfs_hotplug_event], generating hotplug event
[   28.623861] [drm:drm_sysfs_connector_add], adding "DVI-D-1" to sysfs
[   28.623909] [drm:drm_sysfs_hotplug_event], generating hotplug event
[   28.623931] [drm:drm_sysfs_connector_add], adding "DP-1" to sysfs
[   28.623978] [drm:drm_sysfs_hotplug_event], generating hotplug event
[   28.624490] [drm:cdv_intel_dp_i2c_init], i2c_init DPDDC-B
[   28.624995] [drm:cdv_intel_dp_aux_ch], dp_aux_ch timeout status 0x514400=
64
[   28.625000] [drm:cdv_intel_dp_i2c_aux_ch], aux_ch failed -110
[   28.625503] [drm:cdv_intel_dp_aux_ch], dp_aux_ch timeout status 0x514400=
64
[   28.625507] [drm:cdv_intel_dp_i2c_aux_ch], aux_ch failed -110
[   28.625669] [drm:drm_sysfs_connector_add], adding "DVI-D-2" to sysfs
[   28.625718] [drm:drm_sysfs_hotplug_event], generating hotplug event
[   28.625741] [drm:drm_sysfs_connector_add], adding "DP-2" to sysfs
[   28.625786] [drm:drm_sysfs_hotplug_event], generating hotplug event
[   28.626298] [drm:cdv_intel_dp_i2c_init], i2c_init DPDDC-C
[   28.626603] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.626806] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.666898] [drm:cdv_intel_single_pipe_active], pipe enabled 0
[   28.686768] gma500 0000:00:02.0: trying to get vblank count for disabled=
 pipe 1
[   28.686812] gma500 0000:00:02.0: trying to get vblank count for disabled=
 pipe 1
[   28.726865] [drm:cdv_intel_single_pipe_active], pipe enabled 0
[   28.746737] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:=
VGA-1]
[   28.872705] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:=
VGA-1] probed modes :
[   28.872712] [drm:drm_mode_debug_printmodeline], Modeline 23:"1280x1024" =
60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   28.872720] [drm:drm_mode_debug_printmodeline], Modeline 33:"1280x1024" =
75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   28.872728] [drm:drm_mode_debug_printmodeline], Modeline 34:"1024x768" 7=
5 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   28.872736] [drm:drm_mode_debug_printmodeline], Modeline 25:"1024x768" 7=
5 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   28.872743] [drm:drm_mode_debug_printmodeline], Modeline 35:"1024x768" 7=
0 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   28.872751] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 6=
0 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   28.872759] [drm:drm_mode_debug_printmodeline], Modeline 37:"800x600" 75=
 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   28.872766] [drm:drm_mode_debug_printmodeline], Modeline 29:"800x600" 60=
 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   28.872774] [drm:drm_mode_debug_printmodeline], Modeline 30:"640x480" 75=
 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   28.872781] [drm:drm_mode_debug_printmodeline], Modeline 31:"640x480" 60=
 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   28.872789] [drm:drm_mode_debug_printmodeline], Modeline 32:"720x400" 70=
 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   28.872798] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:=
LVDS-1]
[   28.877231] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adap=
ter intel drm LVDSBLC_B
[   28.877240] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:=
LVDS-1] probed modes :
[   28.877245] [drm:drm_mode_debug_printmodeline], Modeline 24:"1920x1080" =
60 144000 1920 2016 2080 2176 1080 1088 1092 1100 0x8 0xa
[   28.877253] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12=
:DVI-D-1]
[   28.881677] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adap=
ter intel drm HDMIB
[   28.881683] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12=
:DVI-D-1] disconnected
[   28.881688] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14=
:DP-1]
[   28.882192] [drm:cdv_intel_dp_aux_ch], dp_aux_ch timeout status 0x514400=
64
[   28.882197] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14=
:DP-1] disconnected
[   28.882202] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18=
:DVI-D-2]
[   28.886626] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adap=
ter intel drm HDMIC
[   28.886632] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18=
:DVI-D-2] disconnected
[   28.886638] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20=
:DP-2]
[   28.886843] [drm:cdv_dp_detect], DPCD: Rev=3D11 LN_Rate=3Da LN_CNT=3D82 =
LN_DOWNSP=3D41
[   28.887149] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.887353] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.887356] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[   28.887660] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.887867] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.887880] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[   28.888185] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.888389] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.888393] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[   28.888697] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.888901] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.888905] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[   28.889209] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.889412] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.889416] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[   28.889721] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.889924] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.889928] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[   28.890232] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.890436] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.890440] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[   28.890744] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.890947] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.890951] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[   28.891255] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.891459] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.891462] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[   28.891766] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.891971] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[   28.891975] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[   28.892002] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20=
:DP-2] probed modes :
[   28.892007] [drm:drm_mode_debug_printmodeline], Modeline 39:"1024x768" 6=
0 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   28.892015] [drm:drm_mode_debug_printmodeline], Modeline 28:"800x600" 60=
 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   28.892023] [drm:drm_mode_debug_printmodeline], Modeline 27:"800x600" 56=
 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   28.892030] [drm:drm_mode_debug_printmodeline], Modeline 38:"848x480" 60=
 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[   28.892038] [drm:drm_mode_debug_printmodeline], Modeline 26:"640x480" 60=
 25175 640 656 752 800 480 489 492 525 0x40 0xa
[   28.892045] [drm:drm_setup_crtcs],=20
[   28.892051] [drm:drm_enable_connectors], connector 7 enabled? yes
[   28.892055] [drm:drm_enable_connectors], connector 9 enabled? yes
[   28.892060] [drm:drm_enable_connectors], connector 12 enabled? no
[   28.892064] [drm:drm_enable_connectors], connector 14 enabled? no
[   28.892068] [drm:drm_enable_connectors], connector 18 enabled? no
[   28.892073] [drm:drm_enable_connectors], connector 20 enabled? yes
[   28.892078] [drm:drm_target_preferred], looking for cmdline mode on conn=
ector 7
[   28.892082] [drm:drm_target_preferred], looking for preferred mode on co=
nnector 7
[   28.892086] [drm:drm_target_preferred], found mode 1280x1024
[   28.892090] [drm:drm_target_preferred], looking for cmdline mode on conn=
ector 9
[   28.892094] [drm:drm_target_preferred], looking for preferred mode on co=
nnector 9
[   28.892099] [drm:drm_target_preferred], found mode 1920x1080
[   28.892103] [drm:drm_target_preferred], looking for cmdline mode on conn=
ector 20
[   28.892107] [drm:drm_target_preferred], looking for preferred mode on co=
nnector 20
[   28.892111] [drm:drm_target_preferred], found mode 1024x768
[   28.892115] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[   28.892126] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
[   28.892132] [drm:drm_setup_crtcs], desired mode 1920x1080 set on crtc 4
[   28.892208] [drm:cdv_get_max_backlight], LVDS Panel PWM value is 0!
[   28.892213] [drm:cdv_get_max_backlight], LVDS Panel PWM value is 0!
[   28.892224] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 o=
n minor 0
--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:               http://www.eyrie.org/~eagle/faqs/questions.html
the second  :

--Lb0e7rgc7IsuDeGj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlJUuQsACgkQHb1edYOZ4bsJaACfcBz+LVdz6o0XJ7DjhXpmsbz4
hdAAniMsjQjEZ5DXxtA1006JjOQ/djOe
=efdm
-----END PGP SIGNATURE-----

--Lb0e7rgc7IsuDeGj--
