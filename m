Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3HUTfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 15:35:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49896 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab3HUTfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 15:35:06 -0400
Date: Wed, 21 Aug 2013 17:13:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>
Cc: Anton Arapov <anton@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ATTEND] oops.kernel.org prospect
Message-ID: <20130821151302.GA9071@nazgul.tnic>
References: <20130819085405.GA22328@bandura.laptop>
 <20130819145505.GB15178@kroah.com>
 <20130819151643.GC19070@bandura.laptop>
 <20130819153939.GA23875@thunk.org>
 <20130819155202.GF19070@bandura.laptop>
 <20130819212512.GA7918@redhat.com>
 <20130820080243.GB2613@bandura.laptop>
 <20130820082216.GA13078@pd.tnic>
 <20130820123748.GB23101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130820123748.GB23101@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 08:37:48AM -0400, Dave Jones wrote:
> abrt used to have a free-form entry like this. What happened is users
> have no idea what to type in there, so you end up with bugs containing
> things like "don't know" or worse, some crazy moon language you can't
> even read.

Prepend the entry with an informative question maybe:

"Enter bug reproduction information here:"

> Two things worth noting here, are 1) the original kerneloops also
> didn't collect anything like this, and was still very useful, and
> 2) for the more common issues (which let's face it, are going to be
> the only things people really look at) chances are pretty high that
> there's going to be someone also reporting it on lkml, or in a distro
> bug tracker.

Ok.

> What might be useful however, is collecting things like
> dmi/lspci/lsusb etc and _asking_ the user if they're ok with including
> them at time of filing. We might scare off some of the more paranoid
> OMGMYSECRETDATAS users, but chances are high most people won't care.
> This requires the client to have a UI though, which aiui, it currently
> doesn't. Anton?

Definitely a step in the right direction.

> We might also ask if they want to provide an email address for
> feedback, but that leads to a bunch of questions about how we expose
> that to developers without exposing it to spambots.

Right.
