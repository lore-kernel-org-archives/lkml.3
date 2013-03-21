Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab3CUEDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 00:03:55 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:59530 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab3CUEDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 00:03:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130320165339.GA28307@kroah.com>
References: <CAJsYZ5ksvPCR2O39=sj9zeptfppP1w6FM08rw8Aw+L+2dEPCnQ@mail.gmail.com>
	<20130320165339.GA28307@kroah.com>
Date: Thu, 21 Mar 2013 09:33:52 +0530
Message-ID: <CAJsYZ5n40mBCd6x7baQ6MLw1HBAa3cfebm+Aa533uxYVP86o9Q@mail.gmail.com>
Subject: Re: [BUG] staging: android: ashmem: Deadlock during ashmem_mmap and ashmem_read
From: Shankar Brahadeeswaran <shankoo77@gmail.com>
To: Bjorn Bringert <bringert@android.com>, Robert Love <rlove@google.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Why not copy the android developers who wrote this code on this thread?
>
> greg k-h

Adding Robert Love & Bjorn Bringert who added most part of the ashmem code.


> Umm...  why does it need to hold that mutex past having checked that
> asma->file is non-NULL, anyway?
Not sure. As I mentioned even I don't know the full flow of this
driver so unable to reason out. Better to hear from the developers.

Hi Robert, Bjorn,
Can you please help us resolving the deadlock problem being discussed here.
You can look at the first email in this thread for detailed problem description.


Warm Regards,
Shankar
