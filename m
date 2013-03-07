Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab3CGKfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:35:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59911 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545Ab3CGKfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:35:36 -0500
Date: Thu, 7 Mar 2013 11:35:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tero Keski-Valkama <tero.keski-valkama@neter.fi>
Cc: Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Added support for Acer Aspire 5755G fan control.
Message-ID: <20130307103531.GB5239@pd.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABGkUug3XZYeDXY+o8-x4mjZ_seDd7GOrJzMSofhaXZV6Ogf=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 11:41:29AM +0200, Tero Keski-Valkama wrote:
> Are there any news about this? I have received several external
> queries about this functionality, so there's clearly need for this to
> be in the kernel. And the patch does work.

Well, this conversation will definitely need a refresh. The thermal code
has been rewritten recently so you probably want to restart your testing
with 3.9-rc1 which contains the latest state and see if it does fix your
issue.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
