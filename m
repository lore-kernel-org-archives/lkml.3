Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224Ab3D3K0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 06:26:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56398 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759520Ab3D3K0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 06:26:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: MFD: move ssbi driver into drivers/mfd
Date: Tue, 30 Apr 2013 12:26:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Brown <davidb@codeaurora.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org
References: <20130429162115.GA6893@kroah.com> <201304300000.19488.arnd@arndb.de> <20130430101854.GI4563@zurbaran>
In-Reply-To: <20130430101854.GI4563@zurbaran>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304301226.20462.arnd@arndb.de>
X-Provags-ID: V02:K0:A6I08miihn3tz+/l4GbOEYO9XkUe13BL3Ky3uS+CfuR
 o44MYkPPfJqZY04BuIDNygxeaxrxS93VEm++oeZZ9lAcl9XFhD
 Oa2m6zAIOPS1ET9yc408ebXa5MfB9mq1460EjZtQILxr4jqfyk
 DydgC/l+uHlFK+wRs51KsQZYlKapkyx0Q3fG/trpLr+ZRF3Vag
 Grp1xoLIDcgn0WWqzAkoWdMCM9bSDm4k6anPWgZ6fdhTDHOR/6
 4TCENKmTu+z2R8edxb0sqxiM1xc1JA6meRzjAPKRDEIJN86QkP
 odTW4rN9TOzsW2LJ43UNepm/tCAmAIFrQZ66wIqaEg86Egpbok
 8/uFIH72AzcyEKNJnqI0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 April 2013, Samuel Ortiz wrote:
> I suppose we don't expect any non MFD drivers to use this interface ?

Yes, that is correct.

> If that's so, I'll take it through mfd-next.

Ok, thanks!

	Arnd
