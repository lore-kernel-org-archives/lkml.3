Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967843Ab3DSCLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 22:11:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967776Ab3DSCLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 22:11:41 -0400
Date: Thu, 18 Apr 2013 19:11:18 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Oliver Neukum <oneukum@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Bastien Nocera <hadess@hadess.net>, Fabien <fabien.andre@gmail.com>,
        Jarod Wilson <jarod@redhat.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] HID: appleir: add support for Apple ir devices
In-Reply-To: <1366215315-9787-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1304181910340.31201@pobox.suse.cz>
References: <1366215315-9787-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013, Benjamin Tissoires wrote:

> This driver was originally written by James McKenzie, updated by
> Greg Kroah-Hartman, further updated by Bastien Nocera, with suspend
> support added.
> I ported it to the HID subsystem, in order to simplify it a litle
> and allow lirc to use it through hiddev.
> 
> More recent versions of the IR receiver are also supported through
> a patch by Alex Karpenko. The patch also adds support for the 2nd
> and 5th generation of the controller, and the menu key on newer
> brushed metal remotes.
> 
> Tested-by: Fabien André <fabien.andre@gmail.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

I have now applied the patch, thanks everybody for all the work.

-- 
Jiri Kosina
SUSE Labs
