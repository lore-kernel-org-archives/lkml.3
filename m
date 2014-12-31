Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaLaV6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 16:58:02 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41229 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaLaV6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 16:58:00 -0500
MIME-Version: 1.0
In-Reply-To: <20141231214421.GA29273@thunk.org>
References: <54A328C2.5080606@lwfinger.net>
	<alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz>
	<alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz>
	<54A3D955.6020809@broadcom.com>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5DD72E@hasmsx107.ger.corp.intel.com>
	<54A3E1F1.7030807@broadcom.com>
	<alpine.LNX.2.00.1412311505100.31609@pobox.suse.cz>
	<54A41000.3040306@broadcom.com>
	<20141231173113.GA443@thunk.org>
	<54A45D4D.7070302@broadcom.com>
	<20141231214421.GA29273@thunk.org>
Date: Wed, 31 Dec 2014 13:57:59 -0800
X-Google-Sender-Auth: b7gTgF5saj_EpVtpE4GBz7zvNwE
Message-ID: <CA+55aFzp2bWctqpiHyZVC9ZCtW3wN_bPsGjcbqKFgu9KOZtAJw@mail.gmail.com>
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Arend van Spriel <arend@broadcom.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 1:44 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Yeah, the confusing part is that "ip" tends to use "verb object"
> scheme, which is consistent with the Cisco IOS command set it was
> trying to emulate.

Side note: does anybody think that was really a good idea to begin
with? I mean, Cisco iOS is just _soooo_ universally loved, right?

And yeah, I refuse to use "ip link" or other insane commands. Let's
face it, "ifconfig" and "route" are perfectly fine commands, and a
whole lot less confusing than "ip" with random crap after it.  I'm
really not seeing why that "ip" command was seen as an improvement.

(Ok, "ip route" isn't any more complex than "route", but "ip link"
sure as hell isn't simpler than "ifconfig" for most things I can think
of)

                     Linus
