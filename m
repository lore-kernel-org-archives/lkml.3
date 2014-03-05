Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbaCEPYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:24:01 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45368 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759206AbaCEPX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 10:23:57 -0500
Date: Wed, 5 Mar 2014 09:22:12 -0600
From: Felipe Balbi <balbi@ti.com>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: "balbi@ti.com" <balbi@ti.com>, Michal Nazarewicz <mina86@mina86.com>,
        Robert Baldyga <r.baldyga@samsung.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david.a.cohen@linux.intel.com" <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH v2] usb: gadget: return the right length in
 ffs_epfile_io()
Message-ID: <20140305152212.GE16430@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393918497-30916-1-git-send-email-chuansheng.liu@intel.com>
 <531606DB.4010601@cogentembedded.com>
 <20140304160620.GH15233@saruman.home>
 <xa1td2i14u63.fsf@mina86.com>
 <20140304195541.GB24463@saruman.home>
 <27240C0AC20F114CBF8149A2696CBE4A01C3E4C2@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2NLGdgz3UMHa/lqP"
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01C3E4C2@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2NLGdgz3UMHa/lqP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 04, 2014 at 11:38:32PM +0000, Liu, Chuansheng wrote:
> Hi Balbi,
>=20
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Wednesday, March 05, 2014 3:56 AM
> > To: Michal Nazarewicz
> > Cc: Robert Baldyga; Felipe Balbi; Sergei Shtylyov; Liu, Chuansheng;
> > gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> > linux-kernel@vger.kernel.org; david.a.cohen@linux.intel.com
> > Subject: Re: [PATCH v2] usb: gadget: return the right length in ffs_epf=
ile_io()
> >=20
> > On Tue, Mar 04, 2014 at 08:53:40PM +0100, Michal Nazarewicz wrote:
> > > >> On 03/04/2014 10:34 AM, Chuansheng Liu wrote:
> > > >> >@@ -845,12 +845,14 @@ static ssize_t ffs_epfile_io(struct file *f=
ile,
> > struct ffs_io_data *io_data)
> > > >> >  			 * we may end up with more data then user space has
> > > >> >  			 * space for.
> > > >> >  			 */
> > > >> >-			ret =3D ep->status;
> > > >> >-			if (io_data->read && ret > 0 &&
> > > >> >-			    unlikely(copy_to_user(io_data->buf, data,
> > > >> >-						  min_t(size_t, ret,
> > > >> >-						  io_data->len))))
> > > >> >-				ret =3D -EFAULT;
> > > >> >+				ret =3D ep->status;
> > >
> > > On Tue, Mar 04 2014, Felipe Balbi wrote:
> > > >>    Why the indentation jumped suddenly to the right?
> > >
> > > > On Tue, Mar 04, 2014 at 08:01:15PM +0300, Sergei Shtylyov wrote:
> > > > because it was wrong before ;-)
> > >
> > > Yep.  It looks like Robert's [2e4c7553: add aio support] introduced an
> > > if-else-if-else flow but did not indent the code and I didn't caught =
it
> > > when reviewing that patch.
> >=20
> > it's in my testing/next now, I also fixed the comment indentation which
> > was also wrong.
> Thanks your help and the fix for comment indentation also:)

no problem, cheers ;-)

--=20
balbi

--2NLGdgz3UMHa/lqP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTF0EkAAoJEIaOsuA1yqRE0vMP/iGVITSC2uNSGyKmoylgJaZa
lhfP7UeQM85JGCCZHsEUGQsOVyAAEvZ/BQvL0SuQ3YnlGIUBPX7kA7i2qYGKMv0+
FbJzSgIiVevGUHtnuMLxl7DrtYaWkRUTtp9ghgStwyAK3TbAMgdmy0jg04PmwfoX
rpaQOCsqqLGHi6B6dKSbl21pIVE3SFUReIr6uL0YOHID6FqmKcqmfPn8gepChIaz
YNtDET78J0Tc1mh+qWSHk70f5fjskHW/OgFCvy2xG6eEAtHfZPiNzy/LG0ncct1v
G5s/WdVeJ+6WdQFCXAuiSl2znI6RsTo/WxbKoiHBA/8EBn6KYswthvLVBBZ8TtZi
bYFoel9cWyZGj3wUQ62A7IbNC9c5n+f2HRnPOfbKX3fEuanU3xlWEcevYH161pH+
4uAWbgr92mka79xW4U/osYo9+cmvtcCDOH8MNqKyLAATaDda9mrpHbIV7SBpvN/E
mIKq+4LcNIh/vp7l4ztlQpqY9z30HyOkMgSwYr6twgMQ18OBcGCimGh/uexGQdIP
WOyGydtMBB/YgB51ArctC2k7nzYmia7vmKfKZJxWG66OAlG//prABCquRQ3gxnYt
boRaX1DWONt77xDRty8kfqv1WmoE7nOZc3hP1wYj4hbuH3hFLWxzpMl2nSLO/r2i
se/LzSYhF4D+EbD1N6KS
=1sUS
-----END PGP SIGNATURE-----

--2NLGdgz3UMHa/lqP--
