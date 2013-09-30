Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab3I3Nla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:41:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab3I3Nl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:41:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130928175956.8752.50967.stgit@amt.stowe>
References: <20130928175956.8752.50967.stgit@amt.stowe>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com, bhelgaas@google.com,
        linux-am33-list@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mn10300/PCI: Remove pci_mem_start
Date: Mon, 30 Sep 2013 14:41:22 +0100
Message-ID: <5483.1380548482@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Myron Stowe <myron.stowe@redhat.com> wrote:

> Remove unused 'pci_mem_start' variable.
> 
> CC: David Howells <dhowells@redhat.com>
> CC: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
