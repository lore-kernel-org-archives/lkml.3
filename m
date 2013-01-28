Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3A1JXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:23:44 -0500
Received: from stringer.orebokech.com ([88.190.240.207]:54222 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab3A1JXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:23:34 -0500
From: Romain Francoise <romain@orebokech.com>
To: David Miller <davem@davemloft.net>
Cc: mst@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-net: fall back to vmalloc if high-order allocation fails
Organization: orebokech dot com
References: <87k3r31vbc.fsf@silenus.orebokech.com>
	<20130123210411.GA9055@redhat.com>
	<20130127.221137.1761549497221263360.davem@davemloft.net>
Date: Mon, 28 Jan 2013 10:23:32 +0100
In-Reply-To: <20130127.221137.1761549497221263360.davem@davemloft.net> (David
	Miller's message of "Sun, 27 Jan 2013 22:11:37 -0500 (EST)")
Message-ID: <87ham1u0dn.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> I'm not going to apply this vmalloc patch, because if I apply it the
> fundamental problem here just gets swept under the carpet even longer.

No problem, I'll keep this as a local change until vhost-net's allocation
strategy gains some sanity.

Thanks.
