Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3AXQNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 11:13:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35094 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab3AXQNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 11:13:38 -0500
Date: Thu, 24 Jan 2013 17:16:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Lasse =?utf-8?B?S8Okcmtrw6RpbmVu?= <ljkarkk2@cc.hut.fi>
Cc: linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: CPU soft lockup in usb-audio
Message-ID: <20130124161629.GD13471@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Lasse =?utf-8?B?S8Okcmtrw6RpbmVu?= <ljkarkk2@cc.hut.fi>,
	linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
References: <510159D2.7000001@cc.hut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <510159D2.7000001@cc.hut.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 05:57:06PM +0200, Lasse Kärkkäinen wrote:
> I've spent months hunting for this random crash bug until today when
> I finally found a way to reliably reproduce it (run a software that
> I develop under valgrind). Log received over netconsole:
> 
> http://pastie.org/5848168
> 
> Is this a known issue or do you need more information to debug it?

Hmm, this happens while running memcheck-<something>.

A couple of things:

* can you try the same way of reproduction without the proprietary
nvidia module loaded?

* can you try latest kernel, 3.8-rc4 or 3.7-stable?

* let's also add linux-usb to CC.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
