Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaKJEoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:44:06 -0500
Received: from muin.pair.com ([209.68.1.55]:53512 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaKJEoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:44:05 -0500
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Nov 2014 23:44:05 EST
MIME-Version: 1.0
In-Reply-To: <5432ABCE.90208@freescale.com>
References: <1412429015-30564-1-git-send-email-German.Rivera@freescale.com>
	<1412429015-30564-4-git-send-email-German.Rivera@freescale.com>
	<CAOZdJXWP4bwWiEcX10i4j96z49QahtpywK=XiuHm9VXWa0zOKw@mail.gmail.com>
	<5432ABCE.90208@freescale.com>
Date: Sun, 9 Nov 2014 22:37:48 -0600
Message-ID: <CAOZdJXW-6+H0XYxx2J8S-tVe4XHODsrk-sAOpy5V+S8sHVggWA@mail.gmail.com>
Subject: Re: [PATCH 3/3 v3] drivers/bus: Device driver for FSL-MC DPRC devices
From: Timur Tabi <timur@tabi.org>
To: German Rivera <German.Rivera@freescale.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        stuart.yoder@freescale.com, Kim Phillips <Kim.Phillips@freescale.com>,
        Scott Wood <scottwood@freescale.com>, Alexander Graf <agraf@suse.de>,
        bhamciu1@freescale.com, R89243@freescale.com,
        Geoff.Thorpe@freescale.com, bhupesh.sharma@freescale.com,
        nir.erez@freescale.com, richard.schmitt@freescale.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 6, 2014 at 9:48 AM, German Rivera
<German.Rivera@freescale.com> wrote:
>>
>> I didn't notice this earlier, but I it was Freescale policy to use
>> EXPORT_SYMBOL() instead of EXPORT_SYMBOL_GPL().  Has that changed?
>>
> Please see change history in the cover letter for this patch series.

So I looked at the change history, and I looked at
http://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg708858.html,
and I don't see any explanation why you changed it to _GPL.  Like I
said, last I checked, it was Freescale policy to use EXPORT_SYMBOL
only, so I still don't understand why you made the change.
