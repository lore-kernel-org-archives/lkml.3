Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaBSVhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:37:16 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:51868 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaBSVhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:37:14 -0500
Date: Wed, 19 Feb 2014 13:37:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] Set bounds on what /proc/self/make-it-fail accepts.
In-Reply-To: <CAC5umyi2VSQZfUfNswSBzB3QuKq4Osm3oof88b1o1Gi-sc6xVQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402191336130.31921@chino.kir.corp.google.com>
References: <20140218220606.GA9712@redhat.com> <alpine.DEB.2.02.1402181429060.20772@chino.kir.corp.google.com> <20140218232702.GA26051@redhat.com> <CAC5umyi2VSQZfUfNswSBzB3QuKq4Osm3oof88b1o1Gi-sc6xVQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014, Akinobu Mita wrote:

> I don't have any plans to extend /proc/self/make-it-fail to support
> other than 0 or 1.  So I have no objection against this change.
> 
> Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
> 

Ok, thanks.  I hoped that the simple_strtol() would have been replaced by 
kstrtoint() since it's the preferred interface to make a lot of this 
simpler and then just test for val == !!val, but the minimal change is 
fine as well.

Acked-by: David Rientjes <rientjes@google.com>
