Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaCCLWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:22:50 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50856 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbaCCLWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:22:47 -0500
Message-ID: <531465FF.1000201@ti.com>
Date: Mon, 3 Mar 2014 13:22:39 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 00/11] SimpleDRM & Sysfb
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>	<53145591.4070004@ti.com>	<CANq1E4QJqB0CSNeSh2jsp90ZtcLwFwfSG=qjodSLdV_aGbL3BQ@mail.gmail.com>	<53145D42.9080806@ti.com> <CANq1E4QYuMsj3W80jiyOfeYr+Xm=J096idyvgCUpFhADWR1ZvA@mail.gmail.com>
In-Reply-To: <CANq1E4QYuMsj3W80jiyOfeYr+Xm=J096idyvgCUpFhADWR1ZvA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="rRLGrhM2GttIgDxSs0D7g7w7vI1nx8ltx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rRLGrhM2GttIgDxSs0D7g7w7vI1nx8ltx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/03/14 13:09, David Herrmann wrote:

>> What do you think, would it be possible to keep the sysfb stuff in
>> arch/x86, and still be able to do the rest of the stuff here? And then=

>> move the sysfs from arch/x86 to drivers/video later?
>=20
> I don't think there's any need for that. Linus does conflict
> resolution all day long, so a short hint in Dave's pull-request (plus
> an example merge) should be enough. Same is true for -next, I think.

True, but, well, the conflict with this one is not a few lines. "git
diff |wc -l" gives 2494 lines for the conflict. It's not really complex
to resolve that one, though, as it's really about copying all the stuff
into its new place.

So I'm not sure if that makes Linus think "this is simple one, 30 secs
and done" or "who the f*** sends me this crap" ;). Especially for two
reasons:

- The fb-reogranization is not very critical, and often clean-ups are
not worth it (although I think this one is good one, of course).
- Conflicting fbdev changes coming from another tree

> And this is really just a mechanical thing, nothing hard to do. But of
> course, it's your decision. However, keeping the code in x86 is the
> wrong thing to do. As discussed with Ingo, the patch that extends

Yes, I didn't mean keeping the code in x86 for good, but just for one
kernel version to make merging easier.

> x86/sysfb is only provided for easier backporting. The followup patch
> immediately removes it again and adds proper video/sysfb. I'd dislike
> splitting these just to avoid merge conflicts. I can also maintain a
> merge-fixup branch in my tree, if anyone wants that.

You can have a try at merging. If you think it's trivial, maybe it is
and we can just let Linus handle it:

git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git
work/fb-reorder

 Tomi



--rRLGrhM2GttIgDxSs0D7g7w7vI1nx8ltx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFGX/AAoJEPo9qoy8lh710vYP/0BFi8Glp5kXW+NO1zTGzInI
Pe326BR2D5hCJ74okYVPBSeeAHJAbQH3X5KJskQaZjy+fWOaZc6ce9WdlX6uyJ32
ggD/TJ+mHF71cH17GD7qGjWy/uuD+X5raOTmyCJrBl/qRNjV0EwihVb3k3125KED
RscZVL2KdZuxLNdPqLgNMkHs9wlz0CDH525bX3+SNwOG8yckpOrQcJk6K3rAZOWv
meKzY7OvQ5sHfP4kVE6s807K57PAwkh+dOMYFkG7pn8JppMQGrvzc8rcEtfRgyv7
gz12rcOimTiUBDyJByhf430bhCM48A5E4i+c1aAY8XUR5EdZRpB/vqtK/sZMqJnY
lfttEwx0kfyexJuqb+w4Ko205WwM3A9H/30IF83vleaI1pUGEJZ8x8qF8StnKfjF
nLP+9nEqT5/H2l0VsV7tsCwpVjTqxXsERfz3MdDact7GShSvn7i3FyKEu977NARV
X5shDr46OT6x1xhSLDxzGI8K9KIyUrq6EP05C4abo4atIIh7giUIV7/JRIsimjjw
KuvZaxKgHy7q2C4jrln0xw/44mx3NOELdDZ51XR4FkP4tXvbNau9/qmGDxQkuUjg
ThHX2egRWQaDFM3bOsrdR3bAIapE9Dmf8Zo6x1m3IZMbeDo0eJI7PiOooQ5zjYag
A12wTEWasA+s2syqcmEV
=0d07
-----END PGP SIGNATURE-----

--rRLGrhM2GttIgDxSs0D7g7w7vI1nx8ltx--
