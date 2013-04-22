Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3DVWKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 18:10:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab3DVWKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 18:10:41 -0400
Date: Mon, 22 Apr 2013 15:10:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKML-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] cciss: add cciss_allow_hpsa module parameter
Message-Id: <20130422151038.6273759a2172b81ebd84e1af@linux-foundation.org>
In-Reply-To: <20130418184937.GA31252@beardog.cce.hp.com>
References: <20130418184937.GA31252@beardog.cce.hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013 13:49:37 -0500 Mike Miller <mike.miller@hp.com> wrote:

> Add the cciss_allow_hpsa modules parameter. This allows users to use the hpsa
> driver instead of cciss for older controllers.
> Tested with 3.9.0-rc7 in combination with the bug fix submitted Tuesday. My
> apologies for not testing that patch with the correct kernel.

Could you please resend Tuesday's bug fix, with a much better
explanation than v1 had?  It's totally weird and wonderful that there's
an interaction between kdump and one scsi/block driver so let's try to
get a diagnosis into the record.

