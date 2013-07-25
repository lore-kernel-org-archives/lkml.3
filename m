Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3GYBlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:41:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59787 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752715Ab3GYBlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:41:22 -0400
Message-ID: <1374716480.1924.18.camel@joe-AO722>
Subject: Re: [RFC PATCH - diffstat only] include/net: Remove extern from
 function prototypes
From: Joe Perches <joe@perches.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 24 Jul 2013 18:41:20 -0700
In-Reply-To: <kspuuk$k2v$1@ger.gmane.org>
References: <1374602291.3387.17.camel@joe-AO722>
	 <kspuuk$k2v$1@ger.gmane.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 01:27 +0000, Cong Wang wrote:
> On Tue, 23 Jul 2013 at 17:58 GMT, Joe Perches <joe@perches.com> wrote:

You dropped the author from the cc list.
Always reply to the author.

> > Function prototypes don't need to be declared
> > extern in .h files.  It's assumed by the compiler
> > and is as unnecessary as using auto is when
> > declaring automatic/local variables in a block.
> >
> Since we all know this, why bother it?

If everyone knew this, new ones wouldn't be added.
But a lot are.

Removing extern makes prototypes shorter and more readable.
More prototypes fit in a single line
More arguments fit on a multi-line prototypes.

> Having "extern" doesn't harm
> readability, instead it probably helps.

Sure, just like auto does.  Why isn't that used?

> > I believe it makes grepping for extern useful as
> > all the matches are actual variables and structs.
> You need a semantic tool.

No, not really.  I'm fairly comfortable with spatch.
spatch takes a long time to run for a lot of things.



