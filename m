Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaCGNtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:49:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59950 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbaCGNtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:49:06 -0500
Date: Fri, 7 Mar 2014 14:48:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, Jon Ringle <jringle@gridpoint.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Ringle, Jonathan" <Jonathan.Ringle@gridpoint.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add option to build with -O3
Message-ID: <20140307134856.GB5255@pd.tnic>
References: <1393977709-9809-1-git-send-email-jringle@gridpoint.com>
 <20140305050927.GA8534@kroah.com>
 <alpine.DEB.2.02.1403050019300.22601@jringle-ubuntu>
 <CAFLxGvyB0r2RgeFhKoWqgWHLKEMF=BEM8ThRr8Mq6nGtJWQm1w@mail.gmail.com>
 <5319BE19.5000607@gmail.com>
 <5319BEC0.4050006@nod.at>
 <5319C0EC.3040606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5319C0EC.3040606@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 07:51:56AM -0500, Austin S Hemmelgarn wrote:
> I'm not arguing that, I just don't have the time to test it at the
> moment; and, "performance improvement" also can mean different things
> to different people (a lot of RT folks for example don't care if
> things run faster if it makes them much less deterministic).

You people never seem to learn: numbers talk, bullshit walks. It is
*that* simple.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
