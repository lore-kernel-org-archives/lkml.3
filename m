Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3AaNMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:12:34 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35316 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3AaNMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:12:32 -0500
Date: Thu, 31 Jan 2013 14:12:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] rwsem-spinlock: let rwsem write lock stealable
Message-ID: <20130131131228.GB6627@gmail.com>
References: <1359537244-20588-1-git-send-email-yuanhan.liu@linux.intel.com>
 <CANN689GwGh2sHwoP66JjoXs2ZMQAXbVpA0MHQahWq5M+baNfSQ@mail.gmail.com>
 <20130131124004.GA12678@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131124004.GA12678@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:

> BTW, mind to tell a nice test case for mmap_sem?

this one was write-hitting on mmap_sem pretty hard, last I 
checked:

  http://people.redhat.com/mingo/threaded-mmap-stresstest/

Thanks,

	Ingo
