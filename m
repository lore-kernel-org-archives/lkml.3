Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3GJMUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:20:46 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45511 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3GJMUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:20:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130710121521.GB11386@redhat.com>
References: <1373453820-22517-1-git-send-email-artagnon@gmail.com>
 <1373453820-22517-2-git-send-email-artagnon@gmail.com> <20130710121521.GB11386@redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Wed, 10 Jul 2013 17:50:04 +0530
Message-ID: <CALkWK0k49QDWcupnhhgDh4WVP-xT1f2rvDkteChZyjWo48u9qw@mail.gmail.com>
Subject: Re: [PATCH 1/2] virtio tools: strip bad include-path from Makefile
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
>> CFLAGS contains a mysterious "-I ../../usr/include", but no such path
>> exists in the linux tree.  The line was originally introduced in
>> 4e53f78e (tools/virtio: virtio_test tool, 2010-11-29), but no such path
>> existed in the tree even then.
>
> It exists if you do make headers_install.

I see.  Why do we need these (or userspace headers) when /include
exists in the linux tree though?

> So it's handy for old distos where userspace headers don't
> exist or are out of date.

I thought userspace headers (linux-kernel-headers package in my
distribution) are used for building kernel modules that exist as
independent projects outside the linux tree (?).
