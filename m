Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab3COTAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:00:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab3COTAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:00:04 -0400
Date: Fri, 15 Mar 2013 19:59:54 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bryan Wu <cooloney@gmail.com>
Cc: florian.vaussard@epfl.ch, Richard Purdie <rpurdie@rpsys.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] leds: leds-pwm: Defer led_pwm_set() if PWM can
 sleep
Message-ID: <20130315185953.GA11351@avionic-0098.mockup.avionic-design.de>
References: <1359381659-24454-1-git-send-email-florian.vaussard@epfl.ch>
 <1359381659-24454-4-git-send-email-florian.vaussard@epfl.ch>
 <20130130081728.GC13568@avionic-0098.mockup.avionic-design.de>
 <512E2F98.6070404@epfl.ch>
 <51347B06.8090604@epfl.ch>
 <20130304105806.GA28735@avionic-0098.mockup.avionic-design.de>
 <513EFE17.6030203@epfl.ch>
 <CAK5ve-+TfHmvx8fiim2yyZhKbhgieO-WDqd+HG7ViLm=Fk3zNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <CAK5ve-+TfHmvx8fiim2yyZhKbhgieO-WDqd+HG7ViLm=Fk3zNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:W3t4pJzK/VJ1Z31pIqWyzVWsJ5KBbywDRZ8pVaMqhA+
 VrEsOTCvbi047jQl8rEYOcO99Ok2Z33X4fgetncFtDxD3+nOcz
 DUrkRBwtSkWdcKWQve7KWJJ2iyOmZ2SxZCMQpMajhunCyaeRqf
 p+cFW1Z8cDqesaDUkDIlqDGQUEkczrQZ3nYVFry5wBRpOJXapg
 b6kHlprjKVl/gXokdzVyKwzXZ9c0/IKspCplzcik8KW4MOZEAT
 5mFPIuoDo1Jh829kNY24l81Zxmgde5jXSdTZet/g+nabGJOfxg
 7sOqbMIHNaA6OlQMaqYZgC36CfPBSfJyluTE7f1T7IHq9sN3HX
 aSJFyRLCyrkgtyo6jsyEjaA6/AzQzVUGaiY5yOU8Y1OIwvd6KL
 GWP0UXhthyCd8ltUo+aZ12kR3gTheU+umc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 15, 2013 at 10:08:57AM -0700, Bryan Wu wrote:
> On Tue, Mar 12, 2013 at 3:06 AM, Florian Vaussard
> <florian.vaussard@epfl.ch> wrote:
> > Hi Bryan,
> >
> >
> >>>>>
> >>>>> Bryan, I assume that you'll be taking this? It doesn't apply cleanl=
y to
> >>>>> my tree, probably because of Peter's recent changes that you took
> >>>>> through your tree and Florian based his patches on top of that. The
> >>>>> conflict resolution should be trivial, though.
> >>>>>
> >>>>
> >>>> It seems that this patch was not taken. Could you pull it, as the ot=
her
> >>>> part is already in linux-pwm? Or is there any show stopper?
> >>>>
> >>>
> >>> Ping? Who should merge this?
> >>
> >>
> >> I assume Bryan will take it through the LED tree? Patches 1 & 2 went
> >> into v3.9-rc1 through the PWM tree.
> >>
> >
> > Ping ?
> >
>=20
> Hi Florian and Thierry,
>=20
> Sorry, guys. My bad! I'm using GMAIL filtering my emails. This email
> goes into my arm-linux mail list archive and I totally missed it.
>=20
> I can merge this patch into my for-next branch, but it will be in 3.10
> not 3.9-rcX.
>=20
> Or Thierry, can you merge that to 3.9-rcX through your tree with my Ack?

I think 3.10 would be fine. We missed the merge window on this one and
it isn't really a fix so it's a bit late for 3.9 now.

If Florian really absolutely needs this it can probably be done, but if
he can wait another few weeks it's certainly worth taking it through
linux-next for a while just to be safe.

Thierry

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRQ2+pAAoJEN0jrNd/PrOhezQP/3t5ggNMAwIYteE+KApglwK9
HWFkmcqTVKfV5cbPKXlIYXBPyf+pBQmK6DU8MOLlepEkPU86zaL9obKWaaZ7uLP2
yjoFSzSlDjr+aeHbWAujj8kTztLjdYi5FuvQfuh6hXI4so5yiLG0x158/KdmXG0v
85q2CEPC2Qh5kh4L3sIm4AOs8S95NgYSv1DLNx2QKpx3UXsXowIvh9xw76m3OX4h
9FK4J0vUitfvTA2pT1DnXfpn1IUQ6p1nMRbmIVsDRSENEKRKQ5cq+z1QGmIbJn37
YBXCAJHlbdJ2knTJvWAxu0+bvpbNvAPHc0E/7fOhiLD2e92CDn64dmBqVmaacmxg
dWVH0YGXB1QP6vZ557yCEPwKuxJt/hwQ9SlKT0h4nliQvoCA6cvtmb9JAnA7PspA
P+sYJqbMOyGT5uEdrlOcmrE1na2AL36Sxjvy7BpLXh+CeTPFi+sZEpyrEKfnd5aj
Yr4fpL4iYxRn/iLuqPnAIZoS73OauAbtDCUAq+W4LOQEwuS5A7+uwxYCQ1PBNYwF
4zSl444AYrj0MPLTJw7V2VXzHYWp2Ratxp41DPI3bJgp+ATJg11TQLutmwhLYjVS
5fF+yB1LhhyC2ZqYXClgLVOSw23+rJO/1DRCj2b+IqxYMY1peK5Z0mHmkQ/paHJ3
F4rq/o4NlczDSjlswWcq
=+bXe
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
