Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbbAAOWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 09:22:22 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:58526 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbAAOWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 09:22:20 -0500
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
X-Google-Original-From: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
Date: Thu, 1 Jan 2015 17:22:15 +0300
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: WARNING: at drivers/gpu/drm/i915/intel_display.c:11375 [i915] in
 3.19-rc2
Message-ID: <20150101142215.GA2570@yulia-desktop>
Mail-Followup-To: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Daniel Vetter <daniel.vetter@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
X-PGP-Key: fp="21AF 2E6F 04EC 7E11 21C6  E399 2236 2F26 57A3 AEAD";
 id="0x57A3AEAD";
 get=<hkp://pgp.mit.edu/pks/lookup?search=0x22362F2657A3AEAD&op=get>;
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

this warning does not exist in 3.19-rc1, but it happens every boot in
3.19-rc2. If you need any other information or data, I would be glad
to help to debug it.=20

[   12.848428] ------------[ cut here ]------------
[   12.848479] WARNING: CPU: 1 PID: 328 at drivers/gpu/drm/i915/intel_displ=
ay.c:11375 intel_crtc_set_config+0x3de/0xb36 [i915]()
[   12.848482] WARN_ON(!set->fb && (set->num_connectors !=3D 0))
[   12.848484] Modules linked in: i915(E) drm_kms_helper(E) drm(E) snd_hda_=
intel(E) snd_hda_controller(E) i2c_algo_bit(E) snd_hda_codec(E) i2c_core(E)=
 xhci_pci(E) xhci_hcd(E) ehci_pci(E) ehci_hcd(E) usbcore(E) snd_hwdep(E) sn=
d_pcm_oss(E) snd_mixer_oss(E) snd_pcm(E) snd_seq_midi(E) snd_rawmidi(E) snd=
_seq_midi_event(E) snd_seq(E) snd_timer(E) snd_seq_device(E) snd(E) video(E=
) battery(E) ppdev(E) parport_pc(E) usb_common(E) serio_raw(E) lpc_ich(E) e=
vdev(E) mfd_core(E) soundcore(E) button(E) acpi_cpufreq(E) processor(E) cor=
etemp(E) lp(E) parport(E) ext3(E) jbd(E) mbcache(E) sd_mod(E) ata_generic(E=
) btrfs(E) ata_piix(E) pata_via(E) libata(E) raid6_pq(E) thermal(E) scsi_mo=
d(E) fan(E) thermal_sys(E) r8169(E) mii(E) xor(E) zlib_deflate(E) crc32c_ge=
neric(E) libcrc32c(E)
[   12.848531] CPU: 1 PID: 328 Comm: plymouthd Tainted: G            E  3.1=
9.0-rc2-noiommu- #122
[   12.848532] Hardware name: System manufacturer System Product Name/P8H67=
-M PRO, BIOS 3904 04/27/2013
[   12.848533]  0000000000000000 ffffffffa06b3002 ffffffff813c01df ffff8800=
378afcb8
[   12.848535]  ffffffff8103f24b 0000000000000000 ffffffffa06685d8 ffff8800=
00110880
[   12.848537]  ffff8800c83c2d00 ffff8800c8ccb160 ffff8800376c1000 ffff8801=
1a74e000
[   12.848539] Call Trace:
[   12.848544]  [<ffffffff813c01df>] ? dump_stack+0x4a/0x74
[   12.848548]  [<ffffffff8103f24b>] ? warn_slowpath_common+0x9e/0xb7
[   12.848566]  [<ffffffffa06685d8>] ? intel_crtc_set_config+0x3de/0xb36 [i=
915]
[   12.848568]  [<ffffffff8103f30f>] ? warn_slowpath_fmt+0x4a/0x4f
[   12.848584]  [<ffffffffa06685d8>] ? intel_crtc_set_config+0x3de/0xb36 [i=
915]
[   12.848586]  [<ffffffff813c228f>] ? __ww_mutex_lock+0x1c/0x91
[   12.848598]  [<ffffffffa0592985>] ? drm_mode_set_config_internal+0x53/0x=
d7 [drm]
[   12.848604]  [<ffffffffa05f6f15>] ? restore_fbdev_mode+0xae/0xca [drm_km=
s_helper]
[   12.848608]  [<ffffffffa05f8393>] ? drm_fb_helper_restore_fbdev_mode_unl=
ocked+0x24/0x5a [drm_kms_helper]
[   12.848627]  [<ffffffffa06747ea>] ? intel_fbdev_restore_mode+0x1b/0x41 [=
i915]
[   12.848632]  [<ffffffffa0589249>] ? drm_lastclose+0x3c/0x104 [drm]
[   12.848637]  [<ffffffffa0589732>] ? drm_release+0x421/0x457 [drm]
[   12.848639]  [<ffffffff8112cd65>] ? __fput+0xdb/0x177
[   12.848642]  [<ffffffff81054977>] ? task_work_run+0x8e/0xa3
[   12.848645]  [<ffffffff81002814>] ? do_notify_resume+0x64/0x7a
[   12.848647]  [<ffffffff813c4267>] ? int_signal+0x12/0x17
[   12.848649] ---[ end trace da6972fb56a05968 ]---

--=20
Best regards,
Andrey Skvortsov

Secure e-mail with gnupg: See http://www.gnupg.org/
PGP Key ID: 0x57A3AEAD



--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJUpVgXAAoJEAF8y6L1SLCttIoP/1j2iGixl/VdJZP1nxLLKqsZ
0gtjl7emrTFF4WvrGCSaUS8XOQdZP7r+APgodyDwIi3cqge9IGMYfH0EemnfdWI7
EdTMkCkPjrnyOOv56SJ7D0ug4uJzqQayeNRXZfCawlVYKn2347NPSsJHemtVU2iN
P8KxpCgM/114CTb13X3b9IqigfTDr0QnRyWLieCNkSdfgDUxgfEPhWGTQNCdnfbJ
7L3fE9kAY4klV+4OIYVcOjgBCkDC+lkJSG6q3ypVjMKnlYF1PXZUb+Ysie9i+hPX
Sk0y89Hk1ei1IaEnc9+GB4vaL/B8KzPe76Dbc1ZftvtGrVtWFBvTwcP349+T5qtM
aHpXdOoqXiWz805Ijbyn8/GuMgM+W/COjwGqv15YlCg+gpMhooSOAonUKZBLVMiW
L/VbadPHJRRzuaod789KT07DpVOPWQX3+2hwJDrSUp4/PnAF9si4cWNRQb28xJME
nqk1x/KX1fIifhuI3KULFZkMNEQtSXAWy4Mp0LbWThZ9dvvvtqsjXkOue+juPom8
+RQSsNGtR3g45I1K1lGIoWBSrFXqLvJxADqHBofoLi+3xcxT1ugo/wbYeGz+ehMI
FClG5oGHmMr+WKqMel9UP1YBpqWvTI1yPipnXdOuIRtUNRmLilWhQmchcibBRENx
PMihJIU0dSEbQJzr2ycs
=/mzi
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
