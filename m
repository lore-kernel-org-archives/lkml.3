Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3BVXGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 18:06:35 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33389 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755117Ab3BVXGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 18:06:30 -0500
Message-ID: <1361574388.6168.6.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Improve CamelCase test for Page
From: Joe Perches <joe@perches.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Fri, 22 Feb 2013 15:06:28 -0800
In-Reply-To: <CAKocOONj+gEcBXZJXGqoY00mcUf5WpLo7j7JF-S20UZED+pLCA@mail.gmail.com>
References: <20130222204253.A37B931C1C1@corp2gmr1-1.hot.corp.google.com>
	 <1361566784.2030.6.camel@joe-AO722> <1361570508.5608.10.camel@thor.lan>
	 <1361571667.2030.13.camel@joe-AO722>
	 <CAKocOONj+gEcBXZJXGqoY00mcUf5WpLo7j7JF-S20UZED+pLCA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dOn Fri, 2013-02-22 at 15:57 -0700, Shuah Khan wrote:
> What are the guidelines on camelcase warnings on patches. A recent one
> I ran into is on a variable in a structure and fixing it would require
> changing the original variable.

The same as all other checkpatch warnings.
Ignore the ones you don't agree with.

Errors maybe should be fixed.  You should be able
to ignore those too though.

> One would have to change a large portion of the code to fix it. In
> such cases, do we ignore this warning?

Yes.

Taste is always author's choice.

Of course, lots of things depends on the upstream
path and files you chose to work on.

If you're working in drivers/net, most of these
warnings seem more likely to get patches that have
them rejected.

If you're working on drivers/scsi, it seems you
don't have to bother running checkpatch at all.

