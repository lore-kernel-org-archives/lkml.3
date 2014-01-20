Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaATX7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:59:03 -0500
Received: from ozlabs.org ([203.10.76.45]:34400 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbaATX7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:59:00 -0500
Date: Tue, 21 Jan 2014 10:58:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>, Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the imx-mxs tree with the arm tree
Message-Id: <20140121105854.77cebd3229f919ce6e7976b2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__21_Jan_2014_10_58_54_+1100_wbZdp4yluXM4kKVC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Jan_2014_10_58_54_+1100_wbZdp4yluXM4kKVC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got conflicts in
arch/arm/boot/dts/Makefile, arch/arm/boot/dts/imx6dl-hummingboard.dts,
arch/arm/boot/dts/imx6qdl-microsom-ar8035.dtsi and
arch/arm/boot/dts/imx6qdl-microsom.dtsi between commits 728d5599f5d8
("ARM: imx: initial SolidRun HummingBoard support") and d79c363fd9cd
("ARM: imx: initial SolidRun Cubox-i support") from the arm tree and a
series of commits from the imx-mxs tree.

Russell told me that the imx-ims tree changes have not yet been approved
for v3.13 inclusion and they conflict fairly badly, so for today I have
dropped the imx-mxs tree.  Let me know what I should do in the future.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__21_Jan_2014_10_58_54_+1100_wbZdp4yluXM4kKVC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3bhCAAoJEMDTa8Ir7ZwVAgQP/0bovRDpN93VPdMrS1PpZtEy
6nJvcLE1/AXJVm1YM5CNNBf5JJy/YK4rY2CSSl7YhS3U/14sSqI1HeMX6A99SXhP
NWksKI2JoV4oCp8QjpOJJnG6b4OQsxWuenpnGWRP6z7rciPKLcs4eWTrE8OYrgYA
p5GtUSg+eXHp0K+IJkLxXpsOLgNf2uCA+Y8P/UqQu4SCZtY60CsKZlpMryaxxHPV
V/0Ai9xbStZLVNZUpdHT5cBfJKOqvrPTtho2pwWDAbskRZAbqGDkh6KNJeF8xFU2
VJXkTAMf3Xh8w1EN4tfA3VtduyUk/jd1s63hFZ5MaXT8rVg83gUFvxA25AGBP5kY
Ms+qX2zQdha6uIeKzwPIFf41SttMEjP+jZ3hXJ95cRC103jv0jcO68eE13YQfasa
JlKBZjX+jwqv924vza/2wWC6dUf33T2luotH9hMi7r/Qr5h4N2C0IFTmCd7nGnUz
9xK69ZW1G07s955Ge0JAsVV7CIt+4SPmm1AA+UL+GtlZHUkLMyGvOwbU7FZ2DYB0
WaH6OQJYeykhW1akRKqPdO2lJpMjCjwfTxIQ80zqfTdmbzEKJXpPAQLIgWeoMTli
rUsRjI+u8WN2fbmy94DHmhvJOUR2X5sh5SBg4vpImw9z+Y8b6De8U00PhIC1yjCj
bzp+bO+G6cymp1W4otsG
=ocPu
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Jan_2014_10_58_54_+1100_wbZdp4yluXM4kKVC--
