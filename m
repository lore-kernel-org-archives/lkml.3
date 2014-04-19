Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaDSPdA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 11:33:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:53992 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaDSPcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 11:32:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
Date: Sat, 19 Apr 2014 17:30:54 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        lftan.linux@gmail.com, cltang@codesourcery.com
References: <1397824031-4892-1-git-send-email-lftan@altera.com> <53518FAC.8020504@zytor.com>
In-Reply-To: <53518FAC.8020504@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201404191730.54400.arnd@arndb.de>
X-Provags-ID: V02:K0:iVcZ7MBcBE5Wr3UIN+bSasrHuE1KL80otyE6YKM0r37
 VbVJQ3L7P1E0ChH0lg1xBQLBFryNsMwQlr3KqZ7kVjOiE/kLeP
 Xwpb+wqf6nrl02APt8+AdA0A5tIQeaB55PktLiuDV4Or11fKV5
 8UqjM9WaFtmWKKKodiBtJ+9Jpcn6JWqVoaSvEVORAgshO8VEzG
 VsTkgdOx33eoqHt4KXnN72dCazUfg0vkMe/FMYNvsffHD4pgQE
 D7ldd3Ndk9Mg+ozOA61G+8C9wif+xb0HxVap6kD45BFnPo2TLM
 YPlnpT2VlIOJAU7D9Gy+LJuid66crnswBNpVCbliyoWgYiA5FA
 bndeYovQK7TglTRvG9yslHHc8rA7uMYPGRO97smem
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 April 2014, H. Peter Anvin wrote:
> On 04/18/2014 05:26 AM, Ley Foon Tan wrote:
> > This patchset adds the Linux kernel port for Nios II processor from Altera.
> > The nios2 Linux port follows the guidance for new architecture ports using
> > generic headers (including unistd.h).
> 
> Did the generic headers ever get updated to match Linus' guidance that
> any new architecture ports should use a 64-bit time_t?

No, unfortunately not. With my rule that every architecture that gets
added needs to clean up asm-generic some more, to make it easier to add
the next one, we should probably do for nios2.

	Arnd
