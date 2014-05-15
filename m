Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaEOOwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:52:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbaEOOwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:52:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140515145122.29177.65285.stgit@warthog.procyon.org.uk>
References: <20140515145122.29177.65285.stgit@warthog.procyon.org.uk>
To: netdev@vger.kernel.org
Cc: dhowells@redhat.com, Nathaniel Wesley Filardo <nwf@cs.jhu.edu>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] af_rxrpc: Fix XDR length check in rxrpc key demarshalling.
Date: Thu, 15 May 2014 15:52:25 +0100
Message-ID: <29223.1400165545@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is aimed at the net tree.

David
