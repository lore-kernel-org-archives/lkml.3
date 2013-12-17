Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3LQN7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:59:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab3LQN7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:59:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5287D78D.4070601@linux.com>
References: <5287D78D.4070601@linux.com>
To: Levente Kurusa <levex@linux.com>
Cc: dhowells@redhat.com, AFS list <linux-afs@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] afs: dir: remove unused label out_skip
Date: Tue, 17 Dec 2013 13:58:44 +0000
Message-ID: <31119.1387288724@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Levente Kurusa <levex@linux.com> wrote:

> The out_skip label is not used, so remove it.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>

Applied.
