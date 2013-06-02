Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3FBMWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 08:22:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57227 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751863Ab3FBMW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 08:22:28 -0400
Message-ID: <1370175747.7400.2.camel@joe-AO722>
Subject: Re: [PATCH V2 6/8] pktcdvd: Convert pr_notice to pkt_notice
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 02 Jun 2013 05:22:27 -0700
In-Reply-To: <CAHp75Vc+bnh+O5UAHiw6czn6VzKeXiOGurdOLMJvwVLK=8aM-g@mail.gmail.com>
References: <1369978679.10556.36.camel@joe-AO722>
	 <cover.1370048648.git.joe@perches.com>
	 <57c43b1b2fdcec5bc95d22654bd4f34df6cc1faf.1370048648.git.joe@perches.com>
	 <CAHp75Vc+bnh+O5UAHiw6czn6VzKeXiOGurdOLMJvwVLK=8aM-g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-02 at 15:12 +0300, Andy Shevchenko wrote:
> On Sat, Jun 1, 2013 at 7:11 AM, Joe Perches <joe@perches.com> wrote:
> > Add a new pkt_notice macro to prefix the name to the logging output.
> 
> One nitpick below.
> 
> > --- a/drivers/block/pktcdvd.c
[]
> > +#define pkt_err(pd, fmt, ...)                                          \
> > +       pr_err("%s: " fmt, pd->name, ##__VA_ARGS__)
> > +#define pkt_notice(pd, fmt, ...)                                       \
> > +       pr_notice("%s: " fmt, pd->name, ##__VA_ARGS__)
> > +
[]
> > -#define pkt_err(pd, fmt, ...)                                          \
> > -       pr_err("%s: " fmt, pd->name, ##__VA_ARGS__)
> 
> May be put this in the right place before?

It all ends up well.  I think it's not worth the bother.

