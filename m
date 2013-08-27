Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab3H0E5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 00:57:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50602 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab3H0E5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 00:57:49 -0400
Date: Tue, 27 Aug 2013 14:57:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [guv 00/16] [RFC] percpu: Replace __get_cpu_var uses throughout
 the kernel
Message-Id: <20130827145738.92ade046470e4f1887d54cbf@canb.auug.org.au>
In-Reply-To: <00000140ac8debd6-6f9e64f9-1107-4336-91ef-77cdf764b96a-000000@email.amazonses.com>
References: <00000140ac8debd6-6f9e64f9-1107-4336-91ef-77cdf764b96a-000000@email.amazonses.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_14_57_38_+1000_1Evf/1470jYKAaZr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_14_57_38_+1000_1Evf/1470jYKAaZr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Fri, 23 Aug 2013 19:01:56 +0000 Christoph Lameter <cl@linux.com> wrote:
>
> At the end of the patchset all uses of __get_cpu_var have been removed so=
 the macro is removed too.

However you get these to Linus, please do not do this last step until the
following merge window.  I can pretty much guarantee that new usages will
be added between the generation of the patch set and their integration.

Its also helpful (to me, at least) if these can be routed via various
subsystem trees to lower the number of conflicts ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Aug_2013_14_57_38_+1000_1Evf/1470jYKAaZr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHDHGAAoJEECxmPOUX5FE2JQP+QFZ+YX/JhkUiG7x62rWIrrz
ETeNt4X58mCvPg/gMCODiLPKuKKwZlmgWzgHbYm5hRJffSuJTfiuEc9TaFOa3+nw
wsbfg1/c4Vv6iIvzRhcEFwFQZV5oYqKYB6QuR8X7UycjhecH7FyGnQYfkKqLsYRF
oJVCzy9O2Gvax3rmG4tqHfJoIKO3KL1ausCphIjUi09W3XsfnZMehtw1eQOVHn9i
IbzknBoaox8iQSVuF/eViW3FL4rxvlYP9pmVupna0U4HNum1ZawrLt4IXKnsDI2k
KubOWmZVh4wcJqr3zc0uEbjiJBy+9GsPSUBxuN3IJBqKAadUcsxkMdr24R+ODUJA
zCRq8Mopo8zHukHDtiMb5Zqod+pmCUihXXMk3ymH/1SydOCE5l8EfrfXJT5HftPE
u7T6P0nXyV+d217t4UpiDSW0SWFORGvWCYmwfJ2tMBnEgtF8t560A2V/Yuk8Geup
j+bB1QYKkAtG/PnPYPFCvGivkendF1b/1ByC6jyIlmwyaj3GlvkzlTqsjQUcCoS2
zWlhwvxnn3mM8c0/NhlNnDhRY2wWftagQ+QHQhXhPpBBSGNv+2KuefGE+u0VTC8y
XgRDXEz/T40gFOe4zIrb4OHJirG3TcJ/ECaRsSR93LQJiVGFm4luO5EgGqNkmWEE
TAq5rBnSGciHFHBp16dk
=RIEh
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_14_57_38_+1000_1Evf/1470jYKAaZr--
