Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbaI2OCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:02:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48968 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbaI2OCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:02:51 -0400
Date: Mon, 29 Sep 2014 09:02:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        <pmeerw@pmeerw.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] iio: light: add support for TI's opt3001 light
 sensor
Message-ID: <20140929140227.GD32403@saruman>
Reply-To: <balbi@ti.com>
References: <20140915052137.GA11866@saruman.home>
 <20140916170316.GD19010@saruman.home>
 <20140917150041.GA6903@saruman.home>
 <20140918133631.GA24847@saruman.home>
 <20140919162129.GE26946@saruman.home>
 <20140922140914.GC25620@saruman>
 <20140923140924.GA28592@saruman>
 <20140924143610.GA17997@saruman>
 <20140925221619.GA10644@saruman>
 <20140927041959.GA28445@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Km1U/tdNT/EmXiR1"
Content-Disposition: inline
In-Reply-To: <20140927041959.GA28445@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Km1U/tdNT/EmXiR1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Alright, this is already ridiculous. Andrew, if I resend the patch can
you apply it since maintainer has been ignoring this thread anyway ?

On Fri, Sep 26, 2014 at 11:19:59PM -0500, Felipe Balbi wrote:
> ping
>=20
> On Thu, Sep 25, 2014 at 05:16:19PM -0500, Felipe Balbi wrote:
> > ping
> >=20
> > On Wed, Sep 24, 2014 at 09:36:10AM -0500, Felipe Balbi wrote:
> > > ping
> > >=20
> > > On Tue, Sep 23, 2014 at 09:09:24AM -0500, Felipe Balbi wrote:
> > > > ping
> > > >=20
> > > > On Mon, Sep 22, 2014 at 09:09:14AM -0500, Felipe Balbi wrote:
> > > > > ping
> > > > >=20
> > > > > On Fri, Sep 19, 2014 at 11:21:29AM -0500, Felipe Balbi wrote:
> > > > > > ping
> > > > > >=20
> > > > > > On Thu, Sep 18, 2014 at 08:36:31AM -0500, Felipe Balbi wrote:
> > > > > > > ping
> > > > > > >=20
> > > > > > > On Wed, Sep 17, 2014 at 10:00:41AM -0500, Felipe Balbi wrote:
> > > > > > > > ping
> > > > > > > >=20
> > > > > > > > On Tue, Sep 16, 2014 at 12:03:16PM -0500, Felipe Balbi wrot=
e:
> > > > > > > > > ping
> > > > > > > > >=20
> > > > > > > > > On Mon, Sep 15, 2014 at 12:21:37AM -0500, Felipe Balbi wr=
ote:
> > > > > > > > > > Hi,
> > > > > > > > > >=20
> > > > > > > > > > On Sat, Sep 13, 2014 at 05:52:02PM +0100, Jonathan Came=
ron wrote:
> > > > > > > > > > > On 02/09/14 16:17, Felipe Balbi wrote:
> > > > > > > > > > > > TI's opt3001 light sensor is a simple and yet power=
ful
> > > > > > > > > > > > little device. The device provides 99% IR rejection,
> > > > > > > > > > > > Automatic full-scale, very low power consumption and
> > > > > > > > > > > > measurements from 0.01 to 83k lux.
> > > > > > > > > > > >=20
> > > > > > > > > > > > This patch adds support for that device using the I=
IO
> > > > > > > > > > > > framework.
> > > > > > > > > > > >=20
> > > > > > > > > > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > > > > > > > > > > ---
> > > > > > > > > > > >=20
> > > > > > > > > > > > Resending as I saw no changes on the thread.
> > > > > > > > > > > Hi Felipe,
> > > > > > > > > > >=20
> > > > > > > > > > > Sorry for the delay on this, entirely my fault - been=
 busy and forgot
> > > > > > > > > > > I still had questions about what was going on in here=
 (yup its the
> > > > > > > > > > > hysteresis bit again!)
> > > > > > > > > >=20
> > > > > > > > > > right, this is starting to become way too much headache=
 for such a
> > > > > > > > > > simple device. Sorry will not help me getting this driv=
er upstream. When
> > > > > > > > > > I first sent this (August 6), we didn't even have v3.17=
-rc1, now we're
> > > > > > > > > > about to tag -rc5 and I'm worried this driver will not =
hit v3.18 merge
> > > > > > > > > > window.
> > > > > > > > > >=20
> > > > > > > > > > > Anyhow, I'm afraid I am still a little confused about=
 the meaning you
> > > > > > > > > > > have assigned to Hysteresis in this driver.
> > > > > > > > > > >=20
> > > > > > > > > > > Let me conjecture on what might be going on here (I m=
ay be entirely
> > > > > > > > > > > wrong).
> > > > > > > > > > >=20
> > > > > > > > > > > Normally a hysteresis value in IIO is defined as the =
'distance' back
> > > > > > > > > > > from a threshold that a signal must go before it may =
retrip the
> > > > > > > > > > > threshold.
> > > > > > > > > > > This threshold value is separately controlled. Thus i=
f we have a
> > > > > > > > > > > rising threshold of 10 and an hysteresis of 2 - to ge=
t two events the
> > > > > > > > > > > signal must first rise past 10, then drop back below =
8 and rise again
> > > > > > > > > > > past 10.
> > > > > > > > > > > If it drops below 10 but not 8 and rises again past 1=
0 then we will
> > > > > > > > > > > not get an event.
> > > > > > > > > > >=20
> > > > > > > > > > > So having the same register for both the hysteresis a=
nd the threshold
> > > > > > > > > > > doesn't with this description make much sense.  It wo=
uld mean that you
> > > > > > > > > > > could only have a threshold of say 10 and a hysteresi=
s of 10, thus in
> > > > > > > > > > > effect meaning the signal would always have to cross =
0 before the next
> > > > > > > > > > > event whatever the combined threshold / hysteresis va=
lue?
> > > > > > > > > > >=20
> > > > > > > > > > > Perhaps instead the device is automatically adjusting=
 the threshold
> > > > > > > > > > > when we cross it and the 'hysteresis' here is with re=
spect to a the
> > > > > > > > > > > previous threshold?
> > > > > > > > > > >=20
> > > > > > > > > > > Thus if we start with a value of 0 and hysteresis is =
set to 2 it will
> > > > > > > > > > > trigger an event at:
> > > > > > > > > > >=20
> > > > > > > > > > > 2, 4, 6, 8, 10 as we rise?
> > > > > > > > > > >=20
> > > > > > > > > > > This sort of auto adjustment of levels isn't uncommon=
 in light sensors
> > > > > > > > > > > (where the point of the interrupt is to notify the op=
erating system
> > > > > > > > > > > that a 'significant' change has occurred and things l=
ike screen
> > > > > > > > > > > brightness may need adjusting.
> > > > > > > > > > >=20
> > > > > > > > > > > If so then the current hysteresis interface does not =
apply, nor does
> > > > > > > > > > > the Rate of Change (ROC) interface as this is depende=
nt on amount of
> > > > > > > > > > > change, not how fast it changed.  Hence we needs some=
thing new to
> > > > > > > > > > > handle this cleanly. I would suggest a new event type=
=2E  Perhaps
> > > > > > > > > > > something with sysfs attr naming along the lines of
> > > > > > > > > > > What:		/sys/.../iio:deviceX/events/in_light_change_ri=
sing_en
> > > > > > > > > > > What:           /sys/.../iio:deviceX/events/in_light_=
change_rising_value
> > > > > > > > > > >=20
> > > > > > > > > > > etc?
> > > > > > > > > >=20
> > > > > > > > > > will you just tell me what you want ? I really cannot g=
ive a crap
> > > > > > > > > > anymore. This has already taken me over a month of my t=
ime for such a
> > > > > > > > > > simple little device, not to mention your confusing and=
 contradicting
> > > > > > > > > > change requests.
> > > > > > > > > >=20
> > > > > > > > > > (could you also trim your responses ? it's very annoyin=
g to scroll so
> > > > > > > > > > much)
> > > > > > > > > >=20
> > > > > > > > > > > > +#define OPT3001_RESULT		0x00
> > > > > > > > > > > > +#define OPT3001_CONFIGURATION	0x01
> > > > > > > > > > > > +#define OPT3001_LOW_LIMIT	0x02
> > > > > > > > > > > > +#define OPT3001_HIGH_LIMIT	0x03
> > > > > > > > > > > > +#define OPT3001_MANUFACTURER_ID	0x7e
> > > > > > > > > > > > +#define OPT3001_DEVICE_ID	0x7f
> > > > > > > > > > > > +
> > > > > > > > > > > > +#define OPT3001_CONFIGURATION_RN_MASK (0xf << 12)
> > > > > > > > > > > > +#define OPT3001_CONFIGURATION_RN_AUTO (0xc << 12)
> > > > > > > > > > > > +
> > > > > > > > > > > > +#define OPT3001_CONFIGURATION_CT	BIT(11)
> > > > > > > > > > > > +
> > > > > > > > > > > > +#define OPT3001_CONFIGURATION_M_MASK	(3 << 9)
> > > > > > > > > > > > +#define OPT3001_CONFIGURATION_M_SHUTDOWN (0 << 9)
> > > > > > > > > > > > +#define OPT3001_CONFIGURATION_M_SINGLE (1 << 9)
> > > > > > > > > > > > +#define OPT3001_CONFIGURATION_M_CONTINUOUS (2 << 9=
) /* also 3 << 9 */
> > > > > > > > > > > > +
> > > > > > > > > > >=20
> > > > > > > > > > > I guess this naming is straight off the datasheet, bu=
t it is rather
> > > > > > > > > > > more cryptic than perhaps it needs to be!  That's kin=
d of an issue
> > > > > > > > > > > with the datasheet choices rather than what you have =
here however!
> > > > > > > > > >=20
> > > > > > > > > > man, are you nit-picky!! These are named as such to mak=
e grepping on
> > > > > > > > > > documentation easier. It's better to have something tha=
t matches
> > > > > > > > > > documentation, don't you think ? otherwise, future user=
s/developers of
> > > > > > > > > > these driver will need either a shit ton of comments ex=
plaining that A
> > > > > > > > > > maps to B in docs, or will need a fscking crystal ball =
to read my mind.
> > > > > > > > > > Assuming I'll still remember what I meant.
> > > > > > > > > >=20
> > > > > > > > > > > > +static int opt3001_remove(struct i2c_client *clien=
t)
> > > > > > > > > > > > +{
> > > > > > > > > > > > +	struct iio_dev *iio =3D i2c_get_clientdata(client=
);
> > > > > > > > > > > > +	struct opt3001 *opt =3D iio_priv(iio);
> > > > > > > > > > > > +	int ret;
> > > > > > > > > > > > +	u16 reg;
> > > > > > > > > > > > +
> > > > > > > > > > > > +	free_irq(client->irq, iio);
> > > > > > > > > > > > +	iio_device_unregister(iio);
> > > > > > > > > > > > +
> > > > > > > > > > > > +	ret =3D i2c_smbus_read_word_swapped(opt->client, =
OPT3001_CONFIGURATION);
> > > > > > > > > > > > +	if (ret < 0) {
> > > > > > > > > > > > +		dev_err(opt->dev, "failed to read register %02x\=
n",
> > > > > > > > > > > > +				OPT3001_CONFIGURATION);
> > > > > > > > > > > > +		return ret;
> > > > > > > > > > > > +	}
> > > > > > > > > > > > +
> > > > > > > > > > > > +	reg =3D ret;
> > > > > > > > > > > > +	opt3001_set_mode(opt, &reg, OPT3001_CONFIGURATION=
_M_SHUTDOWN);
> > > > > > > > > > > > +
> > > > > > > > > > > > +	ret =3D i2c_smbus_write_word_swapped(opt->client,=
 OPT3001_CONFIGURATION,
> > > > > > > > > > > > +			reg);
> > > > > > > > > > > > +	if (ret < 0) {
> > > > > > > > > > > > +		dev_err(opt->dev, "failed to write register %02x=
\n",
> > > > > > > > > > > > +				OPT3001_CONFIGURATION);
> > > > > > > > > > > > +		return ret;
> > > > > > > > > > > > +	}
> > > > > > > > > > > > +
> > > > > > > > > > > > +	iio_device_free(iio);
> > > > > > > > > > >
> > > > > > > > > > > Use the devm_iio_device_alloc and you can drop the ne=
ed to free it.
> > > > > > > > > > > I don't really mind, but I'll almost guarantee that s=
omeone will post
> > > > > > > > > > > a follow up patch doing this if you don't.  As it wil=
l be ever so
> > > > > > > > > > > slightly cleaner, I'll probably take that patch.
> > > > > > > > > >=20
> > > > > > > > > > here's the original driver:
> > > > > > > > > >=20
> > > > > > > > > > http://www.spinics.net/lists/linux-iio/msg14331.html
> > > > > > > > > >=20
> > > > > > > > > > notice that it *WAS* *USING* devm_iio_device_alloc(), u=
ntil:
> > > > > > > > > >=20
> > > > > > > > > > http://www.spinics.net/lists/linux-iio/msg14421.html
> > > > > > > > > >=20
> > > > > > > > > > you *SPECIFICALLY* asked for *NON* *DEVM* versions!!
> > > > > > > > > >=20
> > > > > > > > > > So figure out what you really want, let me know and I'l=
l code it all up
> > > > > > > > > > quickly and hopefully still get this into v3.18 merge w=
indow. I sent
> > > > > > > > > > this driver *very* early to be doubly sure it would hit=
 v3.18 and there
> > > > > > > > > > was a long hiatus from yourself which is now jeopardizi=
ng what I was
> > > > > > > > > > expecting. That, coupled with your contradicting reques=
ts, has just put
> > > > > > > > > > me in a bad mood, even before Monday, hurray.
> > > > > > > > > >=20
> > > > > > > > > > cheers
> > > > > > > > > >=20
> > > > > > > > > > --=20
> > > > > > > > > > balbi
> > > > > > > > >=20
> > > > > > > > >=20
> > > > > > > > >=20
> > > > > > > > > --=20
> > > > > > > > > balbi
> > > > > > > >=20
> > > > > > > >=20
> > > > > > > >=20
> > > > > > > > --=20
> > > > > > > > balbi
> > > > > > >=20
> > > > > > >=20
> > > > > > >=20
> > > > > > > --=20
> > > > > > > balbi
> > > > > >=20
> > > > > >=20
> > > > > >=20
> > > > > > --=20
> > > > > > balbi
> > > > >=20
> > > > >=20
> > > > >=20
> > > > > --=20
> > > > > balbi
> > > >=20
> > > >=20
> > > >=20
> > > > --=20
> > > > balbi
> > >=20
> > >=20
> > >=20
> > > --=20
> > > balbi
> >=20
> >=20
> >=20
> > --=20
> > balbi
>=20
>=20
>=20
> --=20
> balbi



--=20
balbi

--Km1U/tdNT/EmXiR1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKWZzAAoJEIaOsuA1yqREVEQQAKseWd6J2dMgJpqJ8kY8TRrP
+P/ZOQUb+McROdFI6dYnKTmi8dZe4MRAJ0ZjEmmtt6nvBH2wFqqY2cLP1x6V+HFn
GQl5AtcRzOQk0sYppnUHhyAOmqA0YT30FK6Fi2gDAnx71uUATTHuKklQClyhHvvd
duU6x3HC2uZ40NYEl1lB+LKqapf+9YE/d4No3SWUsCkH/QuPSN+c6V4qi3UGq9zn
yloVkib2QLLZMSaiF3sK2EmD7QNHgnUDtXscu3ClERe8tDN5gNdYkYpnb/A2lOup
zwZymf7plYGD+LBAaS2YNmpiummb+e5Pu+7qxJsMLZbPzMVFcJ6GiZzxYgRMgN17
eqYvLs+T2EuzejF/1BlkQfjabpThFO2Mv8PBx9bYBhRZ1ilvUFL7wMxLAmkZX3BU
d3FpHSCh4XmM6S/S+/oZXQdqWsV9WjAj/R3iPnbdyLBXJsuJJjEx/Fkqf0/VC7/x
GFFYohw4SX2IysbpOKBk/X967by40mQSWFxZV/loIm6IrPgZt5WCOwoFfxMuNAU0
HALUIR3DDUpCp1le2l/BgeInjZ8MW1suKTt7mdxx+YYI+LfuXrBQKv8ioP3aFYRg
SKN6q9SSOBWGSErA3KAdE9lKJqxQrWOESvbpMIHCBtRISnGdY+bzaEBKD5STdsfA
VhwEjg++p0bTrKCX+UhR
=uJJ6
-----END PGP SIGNATURE-----

--Km1U/tdNT/EmXiR1--
