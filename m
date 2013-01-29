Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3A2QbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:31:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34026 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753062Ab3A2QbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:31:06 -0500
Message-ID: <1359477064.4196.30.camel@joe-AO722>
Subject: Re: coccinelle and bitmask arithmetic (was: Re: [patch] TTY:
 synclink, small cleanup in dtr_rts())
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Valdis.Kletnieks@vt.edu, cocci@systeme.lip6.fr,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Tue, 29 Jan 2013 08:31:04 -0800
In-Reply-To: <alpine.DEB.2.02.1301291717530.3339@hadrien>
References: <20130127194039.GA18787@elgon.mountain>
	 <1359317078.14406.12.camel@joe-AO722> <20130127201947.GO16282@mwanda>
	 <9561.1359474916@turing-police.cc.vt.edu>
	 <1359475998.4196.26.camel@joe-AO722>
	 <alpine.DEB.2.02.1301291717530.3339@hadrien>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 17:19 +0100, Julia Lawall wrote:
> > On Tue, 2013-01-29 at 10:55 -0500, Valdis.Kletnieks@vt.edu wrote:
[]
> > > I wonder if there's a way to write a coccinelle patch to find places
> > > where we do arithmetic operations on bitmasks....
[]
> If the definition of a bitmask is an identifier in all capital letters,
> that would be easy.  Another possibility is such an identifier that is
> defined to a value expressed beginning with 0x.  Another possibility is
> such an identifier that is sometimes used with & and | and sometimes used
> with an arithmetic operation.  I will give them a try.

Thanks Julia.


