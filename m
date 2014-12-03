Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaLCNNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:13:14 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59907 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbaLCNNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:13:11 -0500
X-Sasl-enc: MFCCqAQxjD4q5pelX/fGlGjt1sz+mi9xbrlD8TF8rqbD 1417612386
Date: Wed, 3 Dec 2014 11:12:54 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-input@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Side effect of pressing special keys
Message-ID: <20141203131254.GB20212@khazad-dum.debian.net>
References: <201411231441.17592@pali>
 <20141203124042.GA504@amd>
 <201412031346.13297@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412031346.13297@pali>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2014, Pali Rohár wrote:
> Ok, and what about KEY_KBDILLUMTOGGLE when bios also handle 
> keyboard backlight level? Should be this key filtered too?

IME, heck yes.

If you ever make the mistake of sending to userspace something the
BIOS/kernel already reacted to, they will find a way to loop it back to you
and cause all sort of issues.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
