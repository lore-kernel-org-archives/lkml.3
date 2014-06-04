Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaFDWXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:23:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbaFDWXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:23:03 -0400
Date: Wed, 4 Jun 2014 18:22:50 -0400
From: Dave Jones <davej@redhat.com>
To: Brandon Philips <brandon.philips@coreos.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Bad rss-counter is back on 3.14-stable
Message-ID: <20140604222250.GA12927@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Brandon Philips <brandon.philips@coreos.com>,
	Greg KH <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140604182739.GA30340@kroah.com>
 <20140604191228.GB12375@redhat.com>
 <CAD2oYtOJbBLrjX9bnNQ5PQnWVdr7ggf=VZWVP3b_KPOPChjd9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD2oYtOJbBLrjX9bnNQ5PQnWVdr7ggf=VZWVP3b_KPOPChjd9Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 12:35:45PM -0700, Brandon Philips wrote:
 > On Wed, Jun 4, 2014 at 12:12 PM, Dave Jones <davej@redhat.com> wrote:
 > > Brandon, what kind of workload is that machine doing ? I wonder if I can
 > > add something to trinity to make it provoke it.
 > 
 > A really boring database workload (fsync() ~50ms) with a sloowww block
 > device with btrfs. There are occasional CPU spikes due to expensive
 > queries.
 > 
 > How can I be more helpful in my workload description?

I feared it would be something like a database. Trying to replicate
things seen under those workloads always seems to be challenging,
in part due to the system specific setups they seem to have.

I wonder if any of the benchmarking apps we have do a realistic
representation of what modern databases do. It might be a fun project
to take something like that and extend it to do random queries.

	Dave

