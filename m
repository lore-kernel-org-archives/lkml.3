Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaFDTfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:35:47 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54944 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaFDTfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:35:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140604191228.GB12375@redhat.com>
References: <20140604182739.GA30340@kroah.com>
	<20140604191228.GB12375@redhat.com>
Date: Wed, 4 Jun 2014 12:35:45 -0700
Message-ID: <CAD2oYtOJbBLrjX9bnNQ5PQnWVdr7ggf=VZWVP3b_KPOPChjd9Q@mail.gmail.com>
Subject: Re: Bad rss-counter is back on 3.14-stable
From: Brandon Philips <brandon.philips@coreos.com>
To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Brandon Philips <brandon.philips@coreos.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 12:12 PM, Dave Jones <davej@redhat.com> wrote:
> Brandon, what kind of workload is that machine doing ? I wonder if I can
> add something to trinity to make it provoke it.

A really boring database workload (fsync() ~50ms) with a sloowww block
device with btrfs. There are occasional CPU spikes due to expensive
queries.

How can I be more helpful in my workload description?

Thanks,

Brandon
