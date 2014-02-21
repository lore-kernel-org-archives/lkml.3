Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbaBUPka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:40:30 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54405 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbaBUPk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:40:27 -0500
Date: Fri, 21 Feb 2014 09:39:05 -0600
From: Felipe Balbi <balbi@ti.com>
To: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140221153905.GE31902@saruman.home>
Reply-To: <balbi@ti.com>
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local>
 <20140220182257.GF23217@saruman.home>
 <a39ce44a-2f92-4067-be6d-7311a78bb195@VA3EHSMHS013.ehs.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lqaZmxkhekPBfBzr"
Content-Disposition: inline
In-Reply-To: <a39ce44a-2f92-4067-be6d-7311a78bb195@VA3EHSMHS013.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lqaZmxkhekPBfBzr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 21, 2014 at 11:27:07AM +0000, Subbaraya Sundeep Bhatta wrote:
> > From the looks of it, I doubt this was actually tested, you need a lot
> > of work on this driver.
> Tested on both ARM and Microblaze architectures with Mass storage gadget.
> Will send a v2 after addressing all your comments.

clearly you didn't try to remove and reinsert the module or you would
see a whole bunch of errors.

> This email and any attachments are intended for the sole use of the
> named recipient(s) and contain(s) confidential information that may be
> proprietary, privileged or copyrighted under applicable law. If you
> are not the intended recipient, do not read, copy, or forward this
> email message or any attachments. Delete this email message and any
> attachments immediately.

remove this footer message, btw, when sending emails to public mailing
lists.

--=20
balbi

--lqaZmxkhekPBfBzr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTB3MZAAoJEIaOsuA1yqREw7MP/2PCe42dNMiNbseVBAcFyptt
LF85jcqOebK2WykWV0HacXmaP2LN+d8VOTMQyJXIFuNlQoocPQnX4GoGS8YMs8GF
zPvrhGAiX/qHFl9GF46IWQWAVbNRHzJwdUnKSJH5X+MM80ya1jWCV7X7mDA/YPDE
rH2MlxNq4pqJQfr18m6i7R5gQDzVtVwUTBXsbIWtR4HA5/KvYA/Tj9Orl51MqZuw
epw/JX+FXgq0QbDfQKIVzTlvlReGCSdsN+5zQZ+pLv3PK6q+xBf1DfcZ3CSvz39F
uXpn8M8xaj9V74l8M/E2FWBLAknbarTDGjW3E5ZHiMuYVc2oUihYWH03qa10kyxf
YQ5GlRXs5medfBunZXs8gyaPb6RDwbSyQeSJxKFC+0nRUUTI091pS+SerOaRG+Ap
u23BrWoiG4bTq/sw4a8NFpsMbnQEAIFw1WHRv8VgJYt1Pzof6ukjWMFacgvptSHY
dWsWdIwVKROb9uip5o9qjVecx3+TP2nKnfnDIPgAUoSq1Yel7PlU4wdZrqKL9ojq
Usa6Hubr6yrdH/XROvGOb4n1zS03NQle7BRVq+p073u3ikHI2oHFPTh1NLC1bcKU
VATUQ5mNBnsBtrvUKvsyFbc03PwCTQCFilYwIINXBXDv5YAWkkumDnRM4VNmxeLs
j86qJpSn/D4sq7RlvVcw
=TYDi
-----END PGP SIGNATURE-----

--lqaZmxkhekPBfBzr--
