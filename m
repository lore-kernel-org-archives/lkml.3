Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab3BSJL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:11:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151Ab3BSJLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:11:24 -0500
Message-ID: <512341B2.6030209@redhat.com>
Date: Tue, 19 Feb 2013 10:11:14 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        asias@redhat.com, mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/9] virtio: new API for addition of buffers, scatterlist
 changes
References: <1360671815-2135-1-git-send-email-pbonzini@redhat.com> <87r4kjjuyn.fsf@rustcorp.com.au> <511CAD19.2010902@redhat.com> <87ehgciw08.fsf@rustcorp.com.au>
In-Reply-To: <87ehgciw08.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/02/2013 08:49, Rusty Russell ha scritto:
> 
> But modulo devastating benchmarks, this wins.  Because the three-part
> API is really, really ugly.  It *looks* like a generic "start - work
> ... work - end" API, but it's not.  Because you need to declare exactly
> what you're doing in virtqueue_start_buf!

Fair enough, and since you did the work for me I cannot really complain. :)

Paolo
