Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3IYLLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:11:23 -0400
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:34292 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab3IYLLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:11:22 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Sep 2013 07:11:22 EDT
Message-ID: <1380107096.4503.8.camel@porter.coelho.fi>
Subject: Re: [PATCH] ti-connectivity: add wl1251 firmware and license
From: Luca Coelho <luca@coelho.fi>
To: Felipe Balbi <balbi@ti.com>
Cc: ben@decadent.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, Pavel Machek <pavel@denx.de>
Date: Wed, 25 Sep 2013 14:04:56 +0300
In-Reply-To: <1380033894-5007-1-git-send-email-balbi@ti.com>
References: <1380033894-5007-1-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi dude,

Great, this is cool! Finally! :)

A few comments...


On Tue, 2013-09-24 at 09:44 -0500, Felipe Balbi wrote:
> It's way overdue that we send these firmware
> blobs upstream. Thanks for everybody involved
> in getting this sorted out.
> 
> Cc: Luciano Coelho <luca@coelho.fi>
> Cc: Pavel Machek <pavel@denx.de>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---

The commit message could be a bit more descriptive rather than
narrative?


>  ti-connectivity/license-wl1251.txt |  59 +++++++++++++++++++++++++++++++++++++

The license file should be in the root, together with the other licenses
and called LICENCE.wl1251 (note the en-GB spelling).  Also, this license
is *very* similar to the one for WiLink6/7/8 (LICENCE.ti-connectivity),
except for some very minor things and the formatting.  Couldn't the same
one be used, for the sake of simplicity and consistency?


>  ti-connectivity/wl1251-fw.bin      | Bin 0 -> 194180 bytes
>  ti-connectivity/wl1251-nvs.bin     | Bin 0 -> 752 bytes
>  3 files changed, 59 insertions(+)
>  create mode 100644 ti-connectivity/license-wl1251.txt
>  create mode 100644 ti-connectivity/wl1251-fw.bin
>  create mode 100644 ti-connectivity/wl1251-nvs.bin

When sending big binary blobs, it's generally better to send pull
requests instead of patches.  If you add the -p option when calling git
pull-request, the text will include all the readable parts but will omit
the binary stuff.

Thank you very much for following up on this!

--
Cheers,
Luca.

