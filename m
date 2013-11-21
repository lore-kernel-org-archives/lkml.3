Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3KUI7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 03:59:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab3KUI7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 03:59:31 -0500
Date: Thu, 21 Nov 2013 09:59:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: James Henstridge <james.henstridge@canonical.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        =?ISO-8859-15?Q?Fabien_Andr=E9?= <fabien.andre@gmail.com>,
        Bastien Nocera <hadess@hadess.net>
Subject: Re: [appleir] BUG: unable to handle kernel NULL pointer
 dereference
In-Reply-To: <CALcaVOmCAV8XeURJ5UpWfaFXoj+bz6DZ1NgAt7Xiv5pfEynRFQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1311210959170.22082@pobox.suse.cz>
References: <20131029145139.GA2788@hercules> <alpine.LNX.2.00.1311061635160.835@pobox.suse.cz> <CALcaVO=jOEqCwLCMUgEkFJMcc4H6bMLU4yvjo1fJ7DeXgkZH6A@mail.gmail.com> <527BB695.9040209@redhat.com> <alpine.LNX.2.00.1311191533200.6657@pobox.suse.cz>
 <CALcaVOmCAV8XeURJ5UpWfaFXoj+bz6DZ1NgAt7Xiv5pfEynRFQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013, James Henstridge wrote:

> Sorry for the delays in testing out the patch.  I have tried a kernel
> with the patch applied, and can no longer reproduce the oops.  The
> hid-appleir driver appears to be working correctly, generating key
> press events in response to the remote, and LIRC functions correctly
> via hiddev.
> 
> Thanks for the everyone's help with this.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
