Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3CZUfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:35:51 -0400
Received: from antcom.de ([188.40.178.216]:46443 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab3CZUfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:35:50 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Mar 2013 16:35:50 EDT
Message-ID: <5152043F.4010307@antcom.de>
Date: Tue, 26 Mar 2013 21:25:35 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: balbi@ti.com
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: Fix compile error by selecting USB_OTG_UTILS
References: <1364319361-28265-1-git-send-email-stigge@antcom.de> <20130326180334.GL20785@arwen.pp.htv.fi> <5151F48C.9060308@gnu.org> <20130326192453.GA21915@arwen.pp.htv.fi>
In-Reply-To: <20130326192453.GA21915@arwen.pp.htv.fi>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: RIPEMD160

On 03/26/2013 08:24 PM, Felipe Balbi wrote:
> commit ?

1c2088812f095df77f4b3224b65db79d7111a300

Seems to be based on the assumption that only OTG needs a PHY.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iD8DBQFRUgQ/caH/YBv43g8RA7RwAKC5HfJmtZonZnwGs6h+hW6Nqi1++wCg25xt
0lckwMSSDwJ4PNiDKqqtRpY=
=Zpq1
-----END PGP SIGNATURE-----
