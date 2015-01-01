Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbbAALcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 06:32:12 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:39766 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbAALcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 06:32:10 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1412311620140.3337@nftneq.ynat.uz>
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
	<CA+55aFzp2bWctqpiHyZVC9ZCtW3wN_bPsGjcbqKFgu9KOZtAJw@mail.gmail.com>
	<54A47B7F.9000403@broadcom.com>
	<alpine.DEB.2.02.1412311620140.3337@nftneq.ynat.uz>
Date: Thu, 1 Jan 2015 12:32:09 +0100
Message-ID: <CAFLxGvxTYkCdUAxePjGi3HkJuG5MihSCxdU+F7vE+H8gWxpiPg@mail.gmail.com>
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
From: Richard Weinberger <richard.weinberger@gmail.com>
To: David Lang <david@lang.hm>
Cc: Arend van Spriel <arend@broadcom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Kosina <jkosina@suse.cz>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
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

On Thu, Jan 1, 2015 at 1:22 AM, David Lang <david@lang.hm> wrote:
> there are things that you can do with "ip" that you can't do with
> "ifconfig", but they tend to be rather esoteric things (hundreds of IP
> addresses on "eth0" without using eth0:1, eth0:2, etc as one example)
>
> The trouble is that doing simple things is harder with "ip" than "ifconfig"

Jan did a nice overview:
http://inai.de/2008/02/19

-- 
Thanks,
//richard
