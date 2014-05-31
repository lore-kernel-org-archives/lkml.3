Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935035AbaEaCKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 22:10:06 -0400
Received: from mail1-ar.fullrate.dk ([90.185.3.41]:53686 "EHLO
	mail1-ar.fullrate.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771AbaEaCKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 22:10:04 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2014 22:10:04 EDT
Message-ID: <53893895.3040202@molgaard.org>
Date: Sat, 31 May 2014 04:04:05 +0200
From: =?UTF-8?B?U3VuZSBNw7hsZ2FhcmQ=?= <sune@molgaard.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0 SeaMonkey/2.29a1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: gregkh@linuxfoundation.org
Subject: [RFC] Summarizing deprecations
X-Enigmail-Version: 1.7a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,

In order to keep this non-code RFC brief, allow me to list a few
observations and then a proposal, that I shall be happy to engage in,
but for which I'd like a bit of guidance:

1) System calls get superseded and deprecated on a regular basis
2) Keeping track of deprecations can be difficult
3) HW vendors with out-of-tree drivers allocate too few resources to
handle 1) and 2)
4) Out-of-tree drivers usually fail to take deprecations into
consideration, and then breaking when deprecation leads to removal

A knee-jerk reaction to 3) might be that they all need to shape up, but
experience seems to relegate that reaction to the pile of wishful
thoughts that lead nowhere.

IIRC, Greg K-H once tried to extend an offer to HW vendors to the effect
of helping with opening their code base, with the reward of helping
write drivers. I don't know what came of it, but I imagine that I would
have heard, if it was a roaring success.

As a user first, and only secondly a developer, I'd like my HW to work,
and finding fully supported gear can still be hard if not impossible,
but I imagine that if we had a central place to list deprecations (and,
possibly, "victims" of them), a lot of grief could be avoided by simply
pointing vendors to that central resource and saying "here is what you
need to know for your driver to keep working - now get to it".

As said, I'm more of a user, so I may be unaware of practices already in
place to mark commits as causing deprecation, but if such practices
exist, I should be able to whip up some sort of script that periodically
does a "git log" and collates deprecations into some format that could
then be parsed by a bash script grepping various out-of-tree code bases
and notifies the relevant parties.

I'd be willing to have a go at such functionality as well as hosting the
info (at least until some vendor realizes the value and donates to it),
but I'd hate to go off into too many wrong directions, if those can be
avoided by feedback here.

Best regards,

Sune Mølgaard
