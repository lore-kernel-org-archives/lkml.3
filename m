Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3CXWp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 18:45:56 -0400
Received: from toccata.ens-lyon.org ([140.77.166.68]:36053 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab3CXWpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 18:45:54 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Mar 2013 18:45:54 EDT
Date: Sun, 24 Mar 2013 23:39:24 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Cox <alan@linux.intel.com>, linux-input@vger.kernel.org,
        jkosina@suse.cz, George Spelvin <linux@horizon.com>,
        chris@the-brannons.com, gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: Caps lock XOR on multiple keyboards?
Message-ID: <20130324223924.GI6234@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@linux.intel.com>,
	linux-input@vger.kernel.org, jkosina@suse.cz,
	George Spelvin <linux@horizon.com>, chris@the-brannons.com,
	gregkh@linuxfoundation.org, jslaby@suse.cz,
	linux-kernel@vger.kernel.org
References: <20121203211911.20156.qmail@science.horizon.com>
 <20121203235848.04228689@bob.linux.org.uk>
 <20130324103018.GA4156@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130324103018.GA4156@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I can confirm that things go fine on the Linux console.  There is just
one state, which is shown on all keyboards.  This is really a bug in
Xorg, please report the issue there.

Pavel Machek, le Sun 24 Mar 2013 11:30:18 +0100, a écrit :
> There is patch to drive keyboard LEDs through LED subsystem, perhaps
> that would be good idea?

My patch won't fix the issue for Xorg, but it'd still be a good thing to
at last apply it :)

Samuel
