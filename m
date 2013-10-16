Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346Ab3JPKFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 06:05:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:48069 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760044Ab3JPKFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:05:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,506,1378882800"; 
   d="asc'?scan'208";a="411811123"
Date: Wed, 16 Oct 2013 05:50:30 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Message-ID: <20131016095030.GA8954@gchen.bj.intel.com>
Mail-Followup-To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
	tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, m.chehab@samsung.com
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
 <20131015165435.GA2777@naverao1-tp.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20131015165435.GA2777@naverao1-tp.ibm.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 15, 2013 at 10:24:35PM +0530, Naveen N. Rao wrote:
> Date: Tue, 15 Oct 2013 22:24:35 +0530
> From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
>  linux-acpi@vger.kernel.org, m.chehab@samsung.com
> Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On 2013/10/11 02:32AM, Chen Gong wrote:
> > Use trace interface to elaborate all H/W error related
> > information.
> >=20
> > Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> > ---
> <snip>
> > +TRACE_EVENT(extlog_mem_event,
> > +	TP_PROTO(u32 etype,
> > +		char *dimm_loc,
> > +		const uuid_le *fru_id,
> > +		char *fru_text,
> > +		u64 error_count,
> > +		u32 severity,
> > +		u64 phy_addr,
> > +		char *mem_loc),
>=20
> [Adding Mauro...]
>=20
> This looks very similar to the trace event I wrote a while back,
> which was similar to the one provided by ghes_edac:
> http://thread.gmane.org/gmane.linux.kernel.pci/24616
>=20
> Seems to me this has the same issues we previously discussed w.r.t
> EDAC conflicts...
>=20
This thread is so long. I have to say I'm lost ...
Anyway, it looks like there are many different opnions on this last
patch. I will send the 2nd version for further discussion soon.


--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSXmFmAAoJEI01n1+kOSLHNwEP/RhFooLMsOOoHRdsbgPkldNT
gBKm6v61kAIjsnKuJqktkG2yYw227sUkHNn+83B8pskFWoUxBrbrIuhlrVM8zpom
Ne3FixMo+GPeqsaVn7XFEgNOfCHmf0V31kbOcYay7PC5W/jURxf1ExRgL5BU+cyv
ZwgqaFdbPTpA1EUHsHzm/zlvXEpQnf+1HYwDPqIg8e3c4CTIfB2wDL4jKnVBu7CD
CyRF8q25rFAD0LHEOz/0fLwvUHd8zZtkRMqOdVUlmJ+W/oSOfru6BWI4Of7GZgRT
j4uWoAfRvT7TVM6SyxxRD3RNg5nhraFJgup+rO4wnlUW7PXFnY/21jtfBPcK18H/
ayxRNr01Z+uzRtB3C4sUrorJvwez3ZHeuKdgyOH5rsyr6+tNHFHegQkC/6VWeiH+
mHqXZA5ixGQw/bs7nlXJI5JMle/3xJEfhfUqo2XfXSN4UH9spcwIeyM/5/xk0X7A
dRxEQzAmn3TfFUwUc5cCBWtqmbskwdpqdM2pk22/iAi7h26pHHlxfkY1zZvQqcYL
e+k+nk/84WR7kCOonbECvNqSRuku+9PIyYdPVr12d21bcwnoBOaSQhZTNWXHq0GK
pRs7WDHl1SmvFE2dLqirA8fnqMoWjkPHj85DC71L87i8xBRJjBBXvS1qz49pLIuZ
e83iSq1rhES88SVGMf6u
=zPHb
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
