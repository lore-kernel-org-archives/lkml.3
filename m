Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaJFSq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:46:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55673 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbaJFSq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:46:27 -0400
Date: Mon, 6 Oct 2014 20:46:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        iss_storagedev@hp.com
Subject: Re: [PATCH 0/7 linux-next] drivers: remove deprecated IRQF_DISABLED
Message-ID: <20141006184623.GC20739@pd.tnic>
References: <1412609755-28627-1-git-send-email-fabf@skynet.be>
 <20141006174050.GA20739@pd.tnic>
 <2020432291.307101.1412620380646.open-xchange@webmail.nmp.skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2020432291.307101.1412620380646.open-xchange@webmail.nmp.skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 08:33:00PM +0200, Fabian Frederick wrote:
>    You're right, I guess we can forget this patchset.
> I didn't see it was already done. (nothing in linux-next yet).

Not the whole patchset - I was replying only to your two patches
touching code in drivers/edac/. I don't know about the rest but yeah,
checking linux-next is always a good idea.

Also, did you CC the proper maintainers for the rest of your patches? If
not, do that and see what they have to say.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
