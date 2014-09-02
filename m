Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbaIBSIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:08:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaIBSIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:08:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1409030056130.7126@namei.org>
References: <alpine.LRH.2.11.1409030056130.7126@namei.org> <20140902125159.9247.11970.stgit@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] KEYS: Miscellaneous fixes
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13490.1409681276.1@warthog.procyon.org.uk>
Date: Tue, 02 Sep 2014 19:07:56 +0100
Message-ID: <13491.1409681276@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> Which of these need to go into current Linus?
> 
> #4 looks like it should.

All of them, preferably, though I'm okay with #3 being deferred.

David
