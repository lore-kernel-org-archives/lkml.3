Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaLBSKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:10:51 -0500
Received: from mail.1ago.be ([178.18.131.20]:37897 "EHLO mail.1ago.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbaLBSKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:10:48 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 13:10:48 EST
Message-ID: <547DFF2F.7090906@1ago.be>
Date: Tue, 02 Dec 2014 19:04:31 +0100
From: 1Ago - Pieter Waegeman <mail@1ago.be>
Reply-To: pieter@1ago.be
Organization: 1Ago
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Matthias Beyer <mail@beyermatthias.de>, Pieter Waegeman <pieter@1ago.be>
CC: klmckinney1@gmail.com, gregkh@linuxfoundation.org,
        tapaswenipathak@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: Fix tab between spaces in InterfaceMacros.h
 This is a patch to the InterfaceMacros.h file that fixes an added tab instead
 of a space. Found by the checkpatch.pl tool.
References: <1417541149-18697-1-git-send-email-pieter@1ago.be> <20141202173957.GJ2314@fu.hfu-open.fu.hs-furtwangen.de>
In-Reply-To: <20141202173957.GJ2314@fu.hfu-open.fu.hs-furtwangen.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Matthias,

Thanks for your feedback!

That's weird. I can still see the driver in the 'master' branch on
https://github.com/torvalds/linux/tree/master/drivers/staging/bcm
I've cloned from
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

Or am I doing something wrong?

- --
Greetings,

Pieter Waegeman

On 02-12-14 18:39, Matthias Beyer wrote:
> Hi Pieter,
>
> as far as I know, this driver was removed from the source tree. Please
> update your local copy of the kernel.
>

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUff8vAAoJENs4BoqSFFN4IN0H/RMITMT1o4+A2rsQ1p3r7aYp
3wamfJPuN0Famlfx03kKS7GKyb7GOdcsbXulDuLJ4Fx+tb1yxoBKwIeaGoNJ6niH
PQVUGNL547Qx5R5koBDPcz4N+Yy/fOKmlj4BhNCSfBZvfEsUOnH2cfrNy5OupPZf
P8DvjLV157uESjC2Hf4+h9EIkp5v363xIUi6TnbaZoDKq3cS16ji8qmKf4JIqE7M
dHX7og902zKGDisJvKk34k7ktJleNsVipfVqvF6MofsNwsqRcatTE4Bzmvai4pKU
gjbFW0v6lDSj/WYYme8idcvoyPc92lrFR9FTXBXsLaN88fjDI4LNnrUY8esi368=
=uJDo
-----END PGP SIGNATURE-----

