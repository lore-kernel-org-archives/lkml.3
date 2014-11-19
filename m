Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbaKSNel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:34:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaKSNek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:34:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAGncdOaqXP0KpiwM3N6dGq_-hEvS-A1n0EJCCL5TSu9o6uc-Sg@mail.gmail.com>
References: <CAGncdOaqXP0KpiwM3N6dGq_-hEvS-A1n0EJCCL5TSu9o6uc-Sg@mail.gmail.com>
To: Anders Eriksson <aeriksson2@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, fabf@skynet.be
Subject: Re: cachefiles: Assertion failed
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27724.1416404071.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 Nov 2014 13:34:31 +0000
Message-ID: <27725.1416404071@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Eriksson <aeriksson2@gmail.com> wrote:

> Using cachefiles to cache my nfsroot raspberryPi on the local SD card I got
> this assertion. It hangs after this happens. It's been unastable since I added
> cachefiles to the mix.

What kernel are you using?

David
