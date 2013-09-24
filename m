Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab3IXJbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:31:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab3IXJbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:31:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1309241206010.4043@tundra.namei.org>
References: <alpine.LRH.2.02.1309241206010.4043@tundra.namei.org> <alpine.LRH.2.02.1309120141280.4317@tundra.namei.org> <alpine.LRH.2.02.1309071426400.29124@tundra.namei.org> <alpine.LRH.2.02.1309070309360.24160@tundra.namei.org> <12075.1378340063@warthog.procyon.org.uk> <17000.1378488989@warthog.procyon.org.uk> <10114.1378806359@warthog.procyon.org.uk> <19686.1379426149@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, simo@redhat.com, zohar@linux.vnet.ibm.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Keyrings patches
Date: Tue, 24 Sep 2013 10:31:31 +0100
Message-ID: <17428.1380015091@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > There's a slight change upstream that means that my patchset needs
> > regenerating (the initconst changes).  Can you bring your -next branch up to
> > date with linus/master so that I can rebase on top of it?
> 
> I've merged my tree to -rc2 so you can rebase or merge (probably better).

Excellent, thanks!

David
