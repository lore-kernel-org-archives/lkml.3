Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3G2TzC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:55:02 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54776 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab3G2Ty6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:54:58 -0400
Message-ID: <51F6C89C.402@gentoo.org>
Date: Mon, 29 Jul 2013 15:55:08 -0400
From: "Rick \"Zero_Chaos\" Farina" <zerochaos@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130524 Thunderbird/17.0.6
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] full listing for RT Systems ftdi devices
References: <1375125479-12617-1-git-send-email-sidhayn@gmail.com>
In-Reply-To: <1375125479-12617-1-git-send-email-sidhayn@gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I probably should have had a v2 in there, but this version does
address the previous feedback.

Thanks,
Rick

On 07/29/2013 03:17 PM, Rick Farina wrote:
> From: "Rick Farina (Zero_Chaos)" <zerochaos@gentoo.org>
> 
> RT Systems makes many usb serial cables based on the ftdi_sio
> driver for programming various amateur radios.  This patch is a
> full listing of their current product offerings and should allow
> these cables to all be recognized.
> 
> Signed-off-by: Rick Farina (Zero_Chaos) <zerochaos@gentoo.org> --- 
> drivers/usb/serial/ftdi_sio.c     | 31
> ++++++++++++++++++++++++++++--- drivers/usb/serial/ftdi_sio_ids.h |
> 34 +++++++++++++++++++++++++++++----- 2 files changed, 57
> insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/usb/serial/ftdi_sio.c
> b/drivers/usb/serial/ftdi_sio.c index 7260ec6..b65e657 100644 ---
> a/drivers/usb/serial/ftdi_sio.c +++
> b/drivers/usb/serial/ftdi_sio.c @@ -735,9 +735,34 @@ static struct
> usb_device_id id_table_combined [] = { { USB_DEVICE(FTDI_VID,
> FTDI_NDI_AURORA_SCU_PID), .driver_info =
> (kernel_ulong_t)&ftdi_NDI_device_quirk }, { USB_DEVICE(TELLDUS_VID,
> TELLDUS_TELLSTICK_PID) }, -	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_SERIAL_VX7_PID) }, -	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_CT29B_PID) }, -	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_RTS01_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_S03_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_59_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_57A_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_57B_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_29A_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_29B_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_29F_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_62B_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_S01_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_63_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_29C_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_81B_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_82B_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_K5D_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_K4Y_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_K5G_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_S05_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_60_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_61_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_62_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_63B_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_64_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_65_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_92_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_92D_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_W5R_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_A5R_PID) }, +	{ USB_DEVICE(RTSYSTEMS_VID,
> RTSYSTEMS_USB_PW1_PID) }, { USB_DEVICE(FTDI_VID,
> FTDI_MAXSTREAM_PID) }, { USB_DEVICE(FTDI_VID, FTDI_PHI_FISCO_PID)
> }, { USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) }, diff --git
> a/drivers/usb/serial/ftdi_sio_ids.h
> b/drivers/usb/serial/ftdi_sio_ids.h index 6dd7925..1b8af46 100644 
> --- a/drivers/usb/serial/ftdi_sio_ids.h +++
> b/drivers/usb/serial/ftdi_sio_ids.h @@ -815,11 +815,35 @@ /* * RT
> Systems programming cables for various ham radios */ -#define
> RTSYSTEMS_VID			0x2100	/* Vendor ID */ -#define
> RTSYSTEMS_SERIAL_VX7_PID	0x9e52	/* Serial converter for VX-7 Radios
> using FT232RL */ -#define RTSYSTEMS_CT29B_PID		0x9e54	/* CT29B
> Radio Cable */ -#define RTSYSTEMS_RTS01_PID		0x9e57	/* USB-RTS01
> Radio Cable */ - +#define RTSYSTEMS_VID		0x2100	/* Vendor ID */ 
> +#define RTSYSTEMS_USB_S03_PID	0x9001	/* RTS-03 USB to Serial
> Adapter */ +#define RTSYSTEMS_USB_59_PID	0x9e50	/* USB-59 USB to 8
> pin plug */ +#define RTSYSTEMS_USB_57A_PID	0x9e51	/* USB-57A USB to
> 4pin 3.5mm plug */ +#define RTSYSTEMS_USB_57B_PID	0x9e52	/* USB-57B
> USB to extended 4pin 3.5mm plug */ +#define RTSYSTEMS_USB_29A_PID
> 0x9e53	/* USB-29A USB to 3.5mm stereo plug */ +#define
> RTSYSTEMS_USB_29B_PID	0x9e54	/* USB-29B USB to 6 pin mini din */ 
> +#define RTSYSTEMS_USB_29F_PID	0x9e55	/* USB-29F USB to 6 pin
> modular plug */ +#define RTSYSTEMS_USB_62B_PID	0x9e56	/* USB-62B
> USB to 8 pin mini din plug*/ +#define RTSYSTEMS_USB_S01_PID	0x9e57
> /* USB-RTS01 USB to 3.5 mm stereo plug*/ +#define
> RTSYSTEMS_USB_63_PID	0x9e58	/* USB-63 USB to 9 pin female*/ 
> +#define RTSYSTEMS_USB_29C_PID	0x9e59	/* USB-29C USB to 4 pin
> modular plug*/ +#define RTSYSTEMS_USB_81B_PID	0x9e5A	/* USB-81 USB
> to 8 pin mini din plug*/ +#define RTSYSTEMS_USB_82B_PID	0x9e5B	/*
> USB-82 USB to 2.5 mm stereo plug*/ +#define RTSYSTEMS_USB_K5D_PID
> 0x9e5C	/* USB-K5D USB to 8 pin modular plug*/ +#define
> RTSYSTEMS_USB_K4Y_PID	0x9e5D	/* USB-K4Y USB to 2.5/3.5 mm plugs*/ 
> +#define RTSYSTEMS_USB_K5G_PID	0x9e5E	/* USB-K5G USB to 8 pin
> modular plug*/ +#define RTSYSTEMS_USB_S05_PID	0x9e5F	/* USB-RTS05
> USB to 2.5 mm stereo plug*/ +#define RTSYSTEMS_USB_60_PID	0x9e60	/*
> USB-60 USB to 6 pin din*/ +#define RTSYSTEMS_USB_61_PID	0x9e61	/*
> USB-61 USB to 6 pin mini din*/ +#define RTSYSTEMS_USB_62_PID	0x9e62
> /* USB-62 USB to 8 pin mini din*/ +#define RTSYSTEMS_USB_63B_PID
> 0x9e63	/* USB-63 USB to 9 pin female*/ +#define
> RTSYSTEMS_USB_64_PID	0x9e64	/* USB-64 USB to 9 pin male*/ +#define
> RTSYSTEMS_USB_65_PID	0x9e65	/* USB-65 USB to 9 pin female null
> modem*/ +#define RTSYSTEMS_USB_92_PID	0x9e66	/* USB-92 USB to 12
> pin plug*/ +#define RTSYSTEMS_USB_92D_PID	0x9e67	/* USB-92D USB to
> 12 pin plug data*/ +#define RTSYSTEMS_USB_W5R_PID	0x9e68	/* USB-W5R
> USB to 8 pin modular plug*/ +#define RTSYSTEMS_USB_A5R_PID	0x9e69
> /* USB-A5R USB to 8 pin modular plug*/ +#define
> RTSYSTEMS_USB_PW1_PID	0x9e6A	/* USB-PW1 USB to 8 pin modular
> plug*/
> 
> /* * Physik Instrumente
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR9sicAAoJEKXdFCfdEflKLBcQAKz7YG3RCZ+AMt312FP1o5Xy
JOvS+ybTedcYgDuS5Fh5G/LI+aqfbb2Q4zshgAjxu9Dx15mHJadGJj//Xg8F/E5H
ea0W24Y+4+VSqwAUiyWNEx8/19HnK3TMLyaRdP6A/XjVIwIt9mOHTGPB43/ZmDz5
KNMiaynIQBuhYyR2mQ9N4cBwKhtrScf7VHh7HmsO+yyfwOafzrRAn94p/gBin2vy
bv0neMRYyjCAvryADEb3RTw8Mv/rRsG3FNELwsa9ipnsUP0Zb9xObftxOFc+LIB2
Gu8/yJPBabNHUCJjaugiGQJ4gvxSdSBr5SZ9O1iEb3f0Z3D9AU2Chtm7A0hr5cEw
kaHTVyY/iVEViZWdgwKC+gB4RM3BUlVBUs/ylmUkvqM+38Q5fiMv+u56nmwJWLWU
DPdcRgtHeWT29fQeqzPVhErxGNh5SvFSSJAA6EQPyWwgb+qjSBQ+++xzPF0o9L2u
Id5vqdxpTU5Y4HQ9+JlhAnHn7EGFheGx962XtJbwRn3Nbe1UUyqB6iioUs5+/0dt
qMWXx3Yqd5DjOc+Q7wLy2DIJJ4XjW/eCzBBpJM5ZRnNv0kXVZilLPxbQb/yV5x0H
GQkuGnidHJF7SgqH2cnjLxOBWgJMCkAePkIvxfw5HyIeOu5eZwRUY+rxaP7iRCKJ
odCMAC7Q+CJuHBeuJgZh
=Vx2Q
-----END PGP SIGNATURE-----
