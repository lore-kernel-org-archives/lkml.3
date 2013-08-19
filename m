Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750959Ab3HSPR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:17:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35108 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3HSPRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:17:24 -0400
Date: Mon, 19 Aug 2013 17:17:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Message-ID: <20130819151721.GA5223@pd.tnic>
References: <20130816152030.GL2133@tuxdriver.com>
 <1376900735.2322.26.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1376900735.2322.26.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 09:25:35AM +0100, David Woodhouse wrote:
> Hm. It would be really useful to have a kernel build option which
> *disables* all the workarounds we've ever put in for broken firmware.

Yeah, cool!

I wonder if we could reach a high double-digit percentage of machines
not booting/barfing on such a clean kernel.

While at it, can we please replace the fw with coreboot? :-)

> Every deviation from the spec (or common sense), however minor, should
> show up as a clear failure. Even the ones we *have* been able to work
> around, because we still want them *fixed*.
> 
> And there's a school of thought that says we should brick as many
> Samsung machines as possible,

Yep, and there's the rooted secure boot asus f*ckup which we should also
advertize while booting, enabling people to use it:

https://www.blackhat.com/us-13/archives.html#Bulygin

/me LOLs ominously...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
