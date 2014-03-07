Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaCGB0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:26:51 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34279 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaCGB0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:26:49 -0500
MIME-Version: 1.0
In-Reply-To: <20140226145345.GG1872@titan.lakedaemon.net>
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20140224181023.GA1010@titan.lakedaemon.net>
	<CACRpkdZ+YGTyDj6i8c198MdRtz3GY-YBmVO9LysPCcmT4EC0cg@mail.gmail.com>
	<20140226000940.GF1872@titan.lakedaemon.net>
	<CACRpkdYQa2BG_qxf5zY=7rks6O31ZF-BX0af3_u1MOgwfwxFSQ@mail.gmail.com>
	<20140226145345.GG1872@titan.lakedaemon.net>
Date: Fri, 7 Mar 2014 09:26:48 +0800
Message-ID: <CACRpkdZRJG-TzN4c3NSH9PqcQzpo6EbEn5_bM-P3sh4_vSjtaA@mail.gmail.com>
Subject: Re: [PATCH 00/10] pinctrl: mvebu: remove hard-coded addresses from
 Dove pinctrl
From: Linus Walleij <linus.walleij@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 10:53 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Wed, Feb 26, 2014 at 10:43:45AM +0100, Linus Walleij wrote:

>> Actually, I'd prefer to pull it in, rebase and sign off each patch
>> individually in my tree if that is not causing you problems.
>
> Actually, that would mess us up pretty badly. :(

OK so I didn't do this, I just pulled it in :-)

>> That way it is visible that the patches were funneled through pin
>> control.
>
> I'm a little confused by this.  Once you merge the branch into one of
> yours, that merge commit is a part of the history.

Yes this has been discussed in the past. But when a developer
bisects down to a certain commit and just looks at it with
git log there is no telling which subsystem this thing came from
and who actually funnelled it to Torvalds.

I do know you *can* find that out with some git magic, the problem
is that it is so magic that most developers don't know it and just
look at the signoffs.

But it's not like I care super-much.

Yours,
Linus Walleij
