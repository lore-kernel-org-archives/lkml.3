Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3GJNWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:22:50 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:51886 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3GJNWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:22:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130710124253.GA12645@redhat.com>
References: <1373453820-22517-1-git-send-email-artagnon@gmail.com>
 <1373453820-22517-2-git-send-email-artagnon@gmail.com> <20130710121521.GB11386@redhat.com>
 <CALkWK0k49QDWcupnhhgDh4WVP-xT1f2rvDkteChZyjWo48u9qw@mail.gmail.com> <20130710124253.GA12645@redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Wed, 10 Jul 2013 18:52:09 +0530
Message-ID: <CALkWK0ky0o-YX7935-sbuunk=HU-=pg8sZiBKiV3P5g9t1zMhQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] virtio tools: strip bad include-path from Makefile
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> This is usespace code so it needs the cleaned-up version from
> usr/include, not the internal kernel one.

Right, thanks for clearing that up.  However, it does seem to depend
on some code in /include in the linux tree.  From
tools/virtio/linux/virtio_ring.h:

  #include "../../../include/linux/virtio_ring.h"
