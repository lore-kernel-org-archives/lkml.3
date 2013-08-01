Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3HAMEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:04:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720Ab3HAMEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:04:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <cover.1375316912.git.joe@perches.com>
References: <cover.1375316912.git.joe@perches.com>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, netdev@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-afs@lists.infradead.org
Subject: Re: [PATCH 0/8] include/net: next set of extern removals
Date: Thu, 01 Aug 2013 13:04:10 +0100
Message-ID: <24958.1375358650@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> Standardize on no extern use on function prototypes

Ugh.  Can we please standardise on _having_ externs on function prototypes?

David
