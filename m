Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbaFYF3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:29:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaFYF3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:29:01 -0400
Date: Wed, 25 Jun 2014 07:28:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: acme@kernel.org, mingo@redhat.com, paulus@samba.org, hpa@zytor.com,
        tglx@linutronix.de, matt@console-pimps.org, dzickus@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] perf/x86/intel: ignore CondChgd bit to avoid false
 NMI handling
Message-ID: <20140625052848.GE6758@twins.programming.kicks-ass.net>
References: <20140625.103503.409316067.d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wDZUCI/4a1lIuQdD"
Content-Disposition: inline
In-Reply-To: <20140625.103503.409316067.d.hatayama@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wDZUCI/4a1lIuQdD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 25, 2014 at 10:35:03AM +0900, HATAYAMA Daisuke wrote:
> This is a resend patch from the previous v2 patch since there's no
> response except for Don.

Thanks, sorry, I got distracted with other things, queued it now.



--wDZUCI/4a1lIuQdD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTql4QAAoJEHZH4aRLwOS67GAP/iuL3CjNPP23blE5RyimVu+B
44ynUv1S2mdjbC4IXn0Ara04wAMaaNSg9hFX6HAJJW99E35mLqF6Pef9x1ZhN9VW
Z1kLM7C6rVQ8633UF2AUcSonEAXDM2qw5wxR16VsNoSvTRWy1XUz90aDExlXvXc1
B6qJqQLAWB2jv5Jfk3jS6cXsWhdX/XbtS8spl10qBJvIQ1Ipasn6SoyAbVvjH2SP
tNTHcu6FPY8eU6eWoDFccMoC2rHY4NBkhJBrK2v8d5wylz9zQk9833Po2MH/GugZ
Ggj8LQT25UvYEtlaIdUbM9+XuRK+taCE5lDmjOxcm/vRAHi+HskxLsiQ/jEUoish
dqFwKVzqQcPzz0Uvy1vdp6xpSLJ+/gNElkA4rQilLYqb0PU6U/ANxRL26gUUQ24o
djrfAPN4GnSiG+1L3i/8b5kBF0YStH0j7oHpSG3TMHb3OvXFj3GX6tA5fG8Ss5Ys
ITJVd0nQcMQvRClq0cxmsVOLtJ4I0tKgdrQ8JjaHGLOiUGp8ZEK2Bg9rA1wLl8zL
QSbFVNWs4kD+FfFC5zDXNhWMca8tMucr/L6DrcOYdOV4bkxRERNILoT90o+NAg3G
U2e+sHd1Q+ZIOf6qNjhrlJJaBzRFf63RsecueOKb2dbLqS3FWG9NzrZtpbRFJxXl
NuPZnmXoBAo04bWPICA0
=jxdF
-----END PGP SIGNATURE-----

--wDZUCI/4a1lIuQdD--
