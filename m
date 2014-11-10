Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaKJFRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:17:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:47939 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaKJFRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:17:24 -0500
Message-ID: <1415596626.5769.14.camel@kernel.crashing.org>
Subject: Re: [RFC] Add of_path property for all devices with a node
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: devicetree@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Date: Mon, 10 Nov 2014 16:17:06 +1100
In-Reply-To: <1415342117.4925.29.camel@kernel.crashing.org>
References: <1415342031.4925.27.camel@kernel.crashing.org>
	 <1415342117.4925.29.camel@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 17:35 +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2014-11-07 at 17:33 +1100, Benjamin Herrenschmidt wrote:
> 
> > So I came up with this patch, 
> 
> And here is the actual patch, which might help :-) It's pretty trivial
> and small...

So not much reactions here .. a bit more on IRC, where Olof suggested
that rather than a file containing a path, we could use a symlink since
the devtree is now in sysfs, so we can do relative links.

That means keeping the legacy "devspec" files in the few places where
they exist, possibly behind a deprecated-default-y config option (though
we might never be able to deprecate them...), but there aren't many.

Any preference either way ?

Cheers,
Ben.


