Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaIJOW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:22:29 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:52877 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbaIJOW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:22:26 -0400
Date: Wed, 10 Sep 2014 09:22:23 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jiri Kosina <jkosina@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
In-Reply-To: <alpine.LNX.2.00.1409100702190.5523@pobox.suse.cz>
Message-ID: <alpine.DEB.2.11.1409100921060.32538@gentwo.org>
References: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz> <20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org> <alpine.LNX.2.00.1409100702190.5523@pobox.suse.cz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Jiri Kosina wrote:

> We obviously don't, as such code will be causing explosions. This is meant
> as a prevention of problems such as the one that has just been fixed in
> ext4.

So we actually think that it is okay to pass an error pointer to kfree
and silently ignore that?

Are we thinking about just accepting any pointer in kfree and ignore
invalid ones?
