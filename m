Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3A3HYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 02:24:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52479 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab3A3HYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 02:24:13 -0500
Date: Wed, 30 Jan 2013 08:24:06 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Mark Zhang <nvmarkzhang@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Mark Zhang <markz@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [RFC 3/4] drm: tegra: use the Common Display Framework
Message-ID: <20130130072406.GA17128@avionic-0098.mockup.avionic-design.de>
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com>
 <1359514939-15653-4-git-send-email-acourbot@nvidia.com>
 <5108C298.1000500@gmail.com>
 <5108C55C.30104@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <5108C55C.30104@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:MpbrQ5lTxAicl8OUOafZnLMZe5+sR34EfSB9AXhMRwo
 +4BYp02SdF34KLQTT7wrQ4obtS2mk3ywV9GOZuFfvv2Kd7mmE8
 IumIjZKfnT9ivTRQSX0L5dlGzthIIK6vCRHAEA/g10UnNovIxG
 a9y7TawBbKuPdoaOFOiYE2KZHfzUzhYLGuGNnMnpV+BSGH15S3
 tHRcrfg1EesKEUT7vE3UG11aDk5hVNMrBfrvX7EBxiX95qRUyk
 aFvsr0TiTVh4IxlF0NWLuOc2k5NDcfpsLrzxOTcF2k+Pz3pKdq
 bzsBvsJwymsWloLT5DD+vl7C/Ip/hE7Cr64Tidu3U/3nqw5ZVl
 JNauegRJRiEGYeK6gz6UfQp9/01kPMpks6xLEACbwzxBlTNHcp
 fP1SOE8qg4P/sIQeT512iyU+J4YnChGH+3AQTDXUP74yCyDRa2
 0RQ9v
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 30, 2013 at 04:01:48PM +0900, Alex Courbot wrote:
> On 01/30/2013 03:50 PM, Mark Zhang wrote:
> >>@@ -147,6 +148,9 @@ struct tegra_output {
> >>
> >>  	struct drm_encoder encoder;
> >>  	struct drm_connector connector;
> >>+	struct display_entity this;
> >>+	struct display_entity *output;
> >
> >Could you pick up a somewhat meaningful name? You know, there are too
> >many variables with name "drm/connector/output/encoder"... :)
>=20
> Well, it's supposed to be abstract. From the CDF point of view it
> could be anything besides a panel. I know this makes it an output of
> an output, but I can't think of anything better right now.

How about renaming "this" to stream to match with what the output is in
CDF speak. And the output's output is the panel, right? Why not just
call it that? Even if it isn't directly connected to a panel entity but
has indeed a whole pipeline in between, for tegra-drm it is still a
panel.

Thierry

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRCMqWAAoJEN0jrNd/PrOhezMQAJkU6eHl9u7E/Ok5OjHxq7aZ
8K+Gmt/DTlSHw0JuVGkd4FzoFGkfx2XFYGyny9uy9cz1zIjpNkJDTMDbLHqc1RM7
BS11WFvvZlQXXGB+b8l0MzGfeksQObbEIyPVxAT9Z70E6t/aW/89g9kikJ5FuOo1
8IILt2c2N2HbFITmqHDEiGTb4D5MSsLrc/0wG9kqz5hGZPEwerWV7ggNiSH9D03+
ZFiRKOdDaS2tOY0Cg1m3i72b8qrj6dsAFKx7GdXOPHjuwWBfjsKOD9iRhffgPzrJ
/AiYEPWNYnfirF85XDQ0nsB3HTEzmViTHHZBLseTfOnJRb6YLClG7B73hILb+7f3
AfbeHpM+Ck8c8aGvUnD4GpM5J+N4HnRMI5bn0pWcewrASGOYItLorLSBDwb1vUxv
Thbp3pE0xbgAsdbv/lFQZHY1v+JlAfiMKzXISF1pg0OWShCjnsVv7j6eenrN7Bm1
RlJH79q89Ana+d3hPfsdA1B20chuRXxT+i+zMR3z8f9DSsGgQwW/t6Pp59cO0XRM
bmIh9WVP5aZ7sYRMetPbDPQa+gwThJRa2Ex8meEK5a8N9BQkK/HImDbvPmeOiffn
vky5bQZCjByMpzh7LYBKJQ7epE63mLPq8oHhF4DJ4j0jBKlr9NrBLdGbuqPL9AwT
4po7D0NFMR7YuaCrJeCu
=wg57
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
