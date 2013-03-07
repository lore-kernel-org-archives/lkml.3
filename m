Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab3CGLD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:03:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40749 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932383Ab3CGLDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:03:25 -0500
Date: Thu, 7 Mar 2013 12:03:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tero Keski-Valkama <tero.keski-valkama@neter.fi>
Cc: Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Added support for Acer Aspire 5755G fan control.
Message-ID: <20130307110321.GC5239@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tero Keski-Valkama <tero.keski-valkama@neter.fi>,
	Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org
References: <1348433304-28320-1-git-send-email-tero.keski-valkama@neter.fi>
 <CABGkUujMCRazGy1+69SWBsS15B97rNEXWNsR4gG8D+5WyeF2jg@mail.gmail.com>
 <20120925090151.GB1247@liondog.tnic>
 <CABGkUugOvWCSfXvLW33jmntGYAAiPP9fStXbdRAozx3bEoKBOA@mail.gmail.com>
 <20120925222417.GA31780@liondog.tnic>
 <cone.1348928745.324944.828.1000@blau>
 <CABGkUug3XZYeDXY+o8-x4mjZ_seDd7GOrJzMSofhaXZV6Ogf=A@mail.gmail.com>
 <20130307103531.GB5239@pd.tnic>
 <CABGkUuhn4PC4KLwLJ_jWPrQxSFZhvVKFrMp8MtqKusOLA6hYRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABGkUuhn4PC4KLwLJ_jWPrQxSFZhvVKFrMp8MtqKusOLA6hYRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 12:50:27PM +0200, Tero Keski-Valkama wrote:
> Yes, I will check that issue, but what about the patch? Is it going
> into the kernel any time soon?

Please regenerate it against the latest kernel 3.9-rc1 and make sure to
test it properly with this kernel and to see whether the interactions
with the new thermal code are ok on your box.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
