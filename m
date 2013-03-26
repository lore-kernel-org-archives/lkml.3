Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab3CZQyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:54:55 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:44832 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3CZQyx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:54:53 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@linux.intel.com>,
        linux-input@vger.kernel.org, jkosina@suse.cz,
        George Spelvin <linux@horizon.com>, chris@the-brannons.com,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: Caps lock XOR on multiple keyboards?
References: <20121203211911.20156.qmail@science.horizon.com>
	<20121203235848.04228689@bob.linux.org.uk>
	<20130324103018.GA4156@amd.pavel.ucw.cz>
	<20130324223924.GI6234@type.youpi.perso.aquilenet.fr>
Date: Tue, 26 Mar 2013 17:54:47 +0100
In-Reply-To: <20130324223924.GI6234@type.youpi.perso.aquilenet.fr> (Samuel
	Thibault's message of "Sun, 24 Mar 2013 23:39:24 +0100")
Message-ID: <87ip4e85k8.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Samuel" == Samuel Thibault <samuel.thibault@ens-lyon.org> writes:

 Samuel> Pavel Machek, le Sun 24 Mar 2013 11:30:18 +0100, a écrit :
 >> There is patch to drive keyboard LEDs through LED subsystem, perhaps
 >> that would be good idea?

 Samuel> My patch won't fix the issue for Xorg, but it'd still be a good
 Samuel> thing to at last apply it :)

Agreed.

-- 
Bye, Peter Korsgaard
