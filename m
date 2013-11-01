Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab3KACRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 22:17:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46660 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3KACQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 22:16:59 -0400
MIME-Version: 1.0
In-Reply-To: <20131031144710.05c08d4a3258098af9312781@linux-foundation.org>
References: <1383062842-28453-1-git-send-email-ming.lei@canonical.com>
	<20131031144710.05c08d4a3258098af9312781@linux-foundation.org>
Date: Fri, 1 Nov 2013 10:16:56 +0800
Message-ID: <CACVXFVPVapjQu4+hzy8zTh6mbKYedpTRDCqu=MyLCy5aLNgUxw@mail.gmail.com>
Subject: Re: [PATCH 1/2] lib/scatterlist: export sg_miter_skip()
From: Ming Lei <ming.lei@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thank you for the comment.

On Fri, Nov 1, 2013 at 5:47 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Looks OK to me.  Please include this in whatever tree is used to merge
> "[PATCH 2/2] USB: storage: use sg_miter_* APIs to access scsi buffer".

Greg and Alan, would you mind reviewing & commenting on 2/2 and merge
the two finally to usb-next tree if you are OK with it?


Thanks,
--
Ming Lei
