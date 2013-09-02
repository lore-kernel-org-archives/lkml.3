Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030Ab3IBVfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 17:35:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758723Ab3IBVfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:35:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <00000140bc5ef9df-d7f75909-a25e-4471-84b2-dfbec07117b0-000000@email.amazonses.com>
References: <00000140bc5ef9df-d7f75909-a25e-4471-84b2-dfbec07117b0-000000@email.amazonses.com> <20130826204351.725357339@linux.com>
To: Christoph Lameter <cl@linux.com>
Cc: dhowells@redhat.com, Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [guv v2 04/31] net: Replace __get_cpu_var uses
Date: Mon, 02 Sep 2013 22:35:06 +0100
Message-ID: <7435.1378157706@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Would it be possible to use __thread annotations for per-CPU variables, I
wonder?

David
