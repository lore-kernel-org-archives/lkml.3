Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab3AYAH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:07:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab3AYAHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:07:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <51019284.4070900@suse.cz>
References: <51019284.4070900@suse.cz> <1358955044-27407-3-git-send-email-mmarek@suse.cz> <1358955044-27407-1-git-send-email-mmarek@suse.cz> <28722.1359040632@warthog.procyon.org.uk>
To: Michal Marek <mmarek@suse.cz>
Cc: dhowells@redhat.com, rusty@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] MODSIGN: Specify the hash algorithm on sign-file command line
Date: Fri, 25 Jan 2013 00:07:07 +0000
Message-ID: <9436.1359072427@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> wrote:

> >> +our ($opt_v, $opt_a);
> > 
> > Should this be 'our' or 'my'?
> 
> These are global variables set by getopts(), so they need to be declared
> 'our'. But I can change it to use the two-argument version of getopts,
> that does not use global variables.

No, that's fine.  Perl seems like black magic at the best of times.

David
