Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab3J1RO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:14:26 -0400
Received: from services.gouders.net ([141.101.32.176]:32908 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab3J1ROY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:14:24 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <sw@simonwunderlich.de>, linux-wireless@vger.kernel.org,
        Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3.12] cfg80211: fix ibss wext chandef creation
In-Reply-To: <1382970069.17956.23.camel@jlt4.sipsolutions.net> (Johannes
	Berg's message of "Mon, 28 Oct 2013 15:21:09 +0100")
References: <1382472166-19563-1-git-send-email-sw@simonwunderlich.de>
	<1382970069.17956.23.camel@jlt4.sipsolutions.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Mon, 28 Oct 2013 18:14:42 +0100
Message-ID: <ghtxg12u7x.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2013-10-22 at 22:02 +0200, Simon Wunderlich wrote:
>> The wext internal chandefs for ibss should be created using the
>> cfg80211_chandef_create() functions. Otherwise the center_freq1 field
>> will not be set and cfg80211_chandef_valid() will spit a warning and
>> report the chandef as invalid when it should be used.
>
> I think
>
> commit f478f33a93f9353dcd1fe55445343d76b1c3f84a
> Author: Bruno Randolf <br1@einfach.org>
> Date:   Thu Sep 26 16:55:28 2013 +0100
>
>     cfg80211: fix warning when using WEXT for IBSS
>
>
> already fixed this. Your patch doesn't apply, but feel free to send me a
> new one (for -next) converting to the creation helpers.

I tested the above commit and it also fixes the problems I noticed here.

Best regards,

Dirk
