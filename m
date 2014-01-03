Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaACQee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:34:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaACQed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:34:33 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1388766184.20141.6.camel@x220>
References: <1388766184.20141.6.camel@x220> <20140103160812.8153.74401.stgit@warthog.procyon.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Fix uninitialised variable warning in mei-amt-version.c
Date: Fri, 03 Jan 2014 16:34:24 +0000
Message-ID: <9629.1388766864@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> wrote:

> But it turns out that call of mei_deinit() isn't needed at all. All of
> the members of mei_cl will be set later in mei_init() and none will be
> used before they are set. So we can simply drop this call of
> mei_deinit()."
> 
> Is that analysis (still) correct?

It looks true as the code stands.  Can you send me your patch?

David
