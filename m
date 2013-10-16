Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762157Ab3JPVHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 17:07:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761828Ab3JPVHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 17:07:38 -0400
Date: Wed, 16 Oct 2013 18:02:51 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] generic kernel watchdog reset at pvclock read (v2)
Message-ID: <20131016210251.GE479@amt.cnet>
References: <20131008010515.516032211@amt.cnet>
 <20131012003924.092908362@amt.cnet>
 <20131016182500.GJ227855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016182500.GJ227855@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 02:25:00PM -0400, Don Zickus wrote:
> On Fri, Oct 11, 2013 at 09:39:24PM -0300, Marcelo Tosatti wrote:
> > v2:
> > - do not create hung_task.h, move defines to sched.h (Don Zickus)
> > - switch patch order (Paolo)
> 
> As long as it solves kvm's problems, I am ok with it.
> 
> Marcelo,
> 
> Is there still corner cases out there that get bit with softlockups or
> hung_task after this patchset?

Not that i am aware of.

> Acked-by: Don Zickus <dzickus@redhat.com>

Thanks.

