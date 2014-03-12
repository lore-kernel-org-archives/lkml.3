Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaCLTwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:52:03 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:51673 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaCLTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:52:01 -0400
Message-ID: <1394653918.31499.206.camel@bobble.lax.corp.google.com>
Subject: Re: [PATCH] block:  Force sector and nr_sects to device alignment
 and granularity.
From: Frank Mayhar <fmayhar@google.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Theodore Tso <tytso@google.com>
Date: Wed, 12 Mar 2014 12:51:58 -0700
In-Reply-To: <x49wqfzyzx5.fsf@segfault.boston.devel.redhat.com>
References: <1394474492.31499.177.camel@bobble.lax.corp.google.com>
	 <x49wqg0bwb4.fsf@segfault.boston.devel.redhat.com>
	 <1394553778.31499.180.camel@bobble.lax.corp.google.com>
	 <x491ty71dox.fsf@segfault.boston.devel.redhat.com>
	 <1394649562.31499.202.camel@bobble.lax.corp.google.com>
	 <x49wqfzyzx5.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 15:33 -0400, Jeff Moyer wrote:
> No, TRIM is advisory, even for well-formed TRIMs.  I guess you could
> alter the definition of successful and have a correct statement there.

Yeah, you're right.  How about "is more likely to be successful."

> Sure, there's no sense getting information from the device and not using
> it.  I guess you've talked me into it.

In fact that was the gist of the local bug I fixed with this.  "The
driver has gone to the trouble of giving us this information, we should
use it."
-- 
Frank Mayhar
310-460-4042

