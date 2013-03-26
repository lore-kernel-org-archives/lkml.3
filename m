Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157Ab3CZTav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:30:51 -0400
Received: from antcom.de ([188.40.178.216]:42315 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab3CZTau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:30:50 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Mar 2013 15:30:50 EDT
Message-ID: <5151F48C.9060308@gnu.org>
Date: Tue, 26 Mar 2013 20:18:36 +0100
From: Roland Stigge <stigge@gnu.org>
Organization: GNU Project
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: balbi@ti.com
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: Fix compile error by selecting USB_OTG_UTILS
References: <1364319361-28265-1-git-send-email-stigge@antcom.de> <20130326180334.GL20785@arwen.pp.htv.fi>
In-Reply-To: <20130326180334.GL20785@arwen.pp.htv.fi>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: RIPEMD160

On 03/26/2013 07:03 PM, Felipe Balbi wrote:
> On Tue, Mar 26, 2013 at 06:36:01PM +0100, Roland Stigge wrote:
>> The current lpc32xx_defconfig breaks like this, caused by recent
>> phy restructuring:
> 
> which commit actually caused this ? I need to know to make sure if
> this should be sent to stable or not.

The issue definitely surfaced after v3.8, so no need for patching
stable, I guess.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iD8DBQFRUfSMcaH/YBv43g8RA70DAKCigz7Qy4f01S9P5dNLH6jxlERF6gCg3H3q
qMlT8LpXfybr588cZFJUjcc=
=45cd
-----END PGP SIGNATURE-----
