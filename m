Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab3KFHtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:49:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab3KFHt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:49:29 -0500
Date: Wed, 6 Nov 2013 09:49:27 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, dzickus@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] generic kernel watchdog reset at pvclock read (v2)
Message-ID: <20131106074927.GR7513@redhat.com>
References: <20131008010515.516032211@amt.cnet>
 <20131012003924.092908362@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131012003924.092908362@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 09:39:24PM -0300, Marcelo Tosatti wrote:
> v2:
> - do not create hung_task.h, move defines to sched.h (Don Zickus)
> - switch patch order (Paolo)
Applied, thanks.

--
			Gleb.
