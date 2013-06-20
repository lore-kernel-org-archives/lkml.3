Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab3FTSfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:35:45 -0400
Received: from sauhun.de ([89.238.76.85]:45762 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758034Ab3FTSfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:35:43 -0400
Date: Thu, 20 Jun 2013 20:37:46 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [RFC] i2c: add deprecation warning for class based instantiation
Message-ID: <20130620183745.GA2961@katana>
References: <20130607090623.GC3428@katana>
 <1370596166-12404-1-git-send-email-wsa@the-dreams.de>
 <20130619101526.GF2950@katana>
 <51C1F6BF.4030200@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <51C1F6BF.4030200@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

> Sorry, for delayed reply - I've had problems with my e-mail.

You still have. This message has unwanted linebreaks.

> I've tested this patch on our TI K3.4 product kernel with additional
> change below:

Thanks.

> [    0.662567]  (null): This adapter will soon drop class based
> instantiation of slaves
>                 ^^^^^ invalid adapter device name here

Good point, thanks! Will send an updated patch in a minute.

> In addition, I've found the following users of *i2c-gpio* (just FYI):

Ehrm, okay, and why exactly did you post it? :)

Regards,

   Wolfram


--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRw0v5AAoJEBQN5MwUoCm21HUQAKIJDSWJxSTcYBvXihSEXNlp
qF/TM0jQGvuWhKBLMuQW4z0HVFTfuxzCa9pvXwRkROfA5o464txZ4H7lqsmkEuTy
PgKiUpNbqdSwt3s6dP8LwI4l5PQqcYYOd87iD8NYZXNoDOoPvHxtAjjFb+OlQj9e
YjbQYpPw2bfuPyXCpQfMh0WwjgtjXfmBOA34UvBbwFZt+hH+bqXIIMKk9uwpeFRF
YX2GOTZON+EoDEAGXeC+XFrgSC40mtX4X62Bnqw9SQKxvAe0DnWJbdcSAol3tOys
q5EJH7kC2kmkC9XSEsBMaSqCOXwtbRhlQVEQJ8nkXk98FbzY17Cm6QICPJ1o+24B
1cbmQ5u3qAHb0+2FZqM03G2HquoPWk/xP9Qoy5TYg80xVHKaQgo7R1l7gHtA8otM
AIbxOMm0uIH0ta4JHxCchML5c4KnTXkAz9VD3+kSLEzO66xQoMSiQFAnQH+4mQMS
FiPTUg2/g/r6o/qNZpzoq9pC5+Otq+BJofq+G68Euqdkpxl8fm5eGyW74cBYXxpA
+1NYLyYbVBYPdcRbTKq3j/vA0Nqvrwde79x0in90KVglUioRn2qP5bubcTosBbOF
R9TjasqqlPPnn/1ltPd0fatDMWKEOLr8Xy5Xhsli3ztFiNbcXWN0rrDt2ugYqPG8
Eb8hD6DcZPeQj68094cA
=Egiz
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
