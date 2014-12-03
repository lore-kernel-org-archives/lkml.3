Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaLCSSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:18:25 -0500
Received: from omr1.cc.vt.edu ([198.82.141.52]:40955 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaLCSSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:18:24 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Sean Cleator <seancleator@hotmail.co.uk>
Cc: lidza.louina@gmail.com, markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dgnc: Fix long line coding style issues in dgnc_cls.h
In-Reply-To: Your message of "Wed, 03 Dec 2014 17:07:28 +0000."
             <BLU437-SMTP66508C574F65742CE8FCDEE97B0@phx.gbl>
From: Valdis.Kletnieks@vt.edu
References: <BLU437-SMTP66508C574F65742CE8FCDEE97B0@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1417630680_17508P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Dec 2014 13:18:00 -0500
Message-ID: <18017.1417630680@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1417630680_17508P
Content-Type: text/plain; charset=us-ascii

On Wed, 03 Dec 2014 17:07:28 +0000, Sean Cleator said:
> A patch to fix the rest of the long line warnings in the dgnc_cls.h file
> found by the checkpatch.pl tool

>  struct cls_uart_struct {
>  	u8 txrx;		/* WR  RHR/THR - Holding Reg */
>  	u8 ier;		/* WR  IER - Interrupt Enable Reg */
> -	u8 isr_fcr;		/* WR  ISR/FCR - Interrupt Status Reg/Fifo Control Reg */
> +	u8 isr_fcr;		/*
> +				 * WR  ISR/FCR - Interrupt Status Reg/Fifo
> +				 * Control Reg
> +				 */
>  	u8 lcr;		/* WR  LCR - Line Control Reg */
>  	u8 mcr;		/* WR  MCR - Modem Control Reg */
>  	u8 lsr;		/* WR  LSR - Line Status Reg */

It may shut up the warning, but is this really an improvement?

--==_Exmh_1417630680_17508P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVH9T2AdmEQWDXROgAQKjpQ//QOr+V+qKaWQQ8WOFoUlhSH86Oz5d45JQ
hhkH3x4PUMqFvPEK/0e4rvsqueto+xX1nUr+GlYcS+9kwtFIlFwzDLkcM+7dVDDt
tIaEQxuGXsj44voHotu9OgIHuU8eH7sT+mBqH5cvD1t2V0S5iBSTmr29b+TlbTci
pmvMuETFTZmPThOcR5R5/5YRH2NXhRFX9sHZiSZMlIYy/lRPHIEVKfG3yPc9yd58
Ib3rRuVVlKW2NdsVJUscs0JOtO6nQMkRurBZ4Usqe5KnsTPVZz7j7CZk/WqP7LYW
TisWau45Vl+CbBdrrus9rRT2MBmRbConNTsCG+eAbjLikLYyRfSUeRMBcBn3E3/S
VYobn2jM6/VBYCVPOzoCckH13gDhQDKNHmpl/oO9LHTSNwUHQlMSkI1Y0bau4/wa
sJC8wSTWxrW/kqobHrVYVtYTPnLryAlOdlyU7mVy7RSbIThc8gxW2QqJLTHBw+2G
Mt0ylQ4S8erV5Cz/rmZw+GvI5H7CtWiPKaTZzUKAjpnYTga1HOR5wKBWshpUl4oq
FDkIhVJ6zzDtk7de+aHEbpdeUETmFtNATmdVPtYXYOpTnJ0HJn5uUu7y2MuD1no4
YHDo55ZDUExGJMSblCwYHZKRfTKGPFERi4gUxvk1dOHhlU2xtXeXECepgbGClx2E
+F5EQiWttxA=
=yQjn
-----END PGP SIGNATURE-----

--==_Exmh_1417630680_17508P--
