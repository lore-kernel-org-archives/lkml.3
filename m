Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783AbaD2Lbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:31:41 -0400
Received: from sauhun.de ([89.238.76.85]:40662 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933455AbaD2Lbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:31:39 -0400
Date: Tue, 29 Apr 2014 13:31:28 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Adam Williamson <awilliam@redhat.com>, Lan Tianyu <tianyu.lan@intel.com>,
        mika.westerberg@linux.intel.com, lenb@kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Lv Zheng <lv.zheng@intel.com>
Subject: Re: [Patch V2 1/9] ACPICA: Executer: Fix buffer allocation issue for
 generic_serial_bus region field accesses.
Message-ID: <20140429113128.GA3640@katana>
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
 <1398707520.2843.16.camel@adam.happyassassin.net>
 <1398708505.2843.17.camel@adam.happyassassin.net>
 <8704550.LJW911OU1k@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <8704550.LJW911OU1k@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> The rest has been queued up for 3.16.

I also aim for 3.16, yet it may take 1 or 2 weeks more until I'll be
able to review the I2C part of those patches.


--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTX42QAAoJEBQN5MwUoCm214AQAJ0LWgQLyyWJ8tLlFUmMZnlV
7g7J03Hlmj2CAIkn5IaOjtVlUq/4rnD3seN0vRlRK+fkS656QwNg96Gje8RXhtIC
KNP+zAGwS5ClJndFv66FKH2EN662Miogbxblo4i0sbYGLw6xNmoo00X8Ablfr5Ii
rmtqYn9A56RPrbEFj+lAn9M0elwgpLx6NDYz/d6U0/+dHT1flQC/oL0JBY0UQwDP
PWzqeqMrm0lQhJKr0RtxqF/R9/mwUPlhmuNqsERZezezivjnmGOD8A/oqaJlpomb
mKz0d94WC4bVkPg8Uiv54zRUfsjCC5wboS0dThCQn1yQ1BBPzWsBoCeSbnRkz9j7
EpioTyH1zsWC+/FAazaZJghx/NRVjqIUNqrXTHT/fFiv76j425wAMK1vscWpDERO
GtKFXt7Xdi247lg+tN6XYzMFn/fQqDMnXDccQz/JHLWG/W/a77iXY3XWFQirZaE5
G3uM/4A7tEyAT4dyC32Lg/iqSJ5qefA5JJ6uaz3+3Rg+h6/T9CaiiVJ84+2R1GzN
AR2N2pUXNxSmATvG+xbqW4Js5sEXBl5udaxlBcY7Sb+R0yHufrn1a/fgF7BLgH3B
v3LKtsWOYzW9m3mKo3hb9NpyJ3CJtIgArVPasjAFFo4uBEykSqORkHcse0vKdMox
hofuJLLJ5R9jrwKV5cbu
=5XlD
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
