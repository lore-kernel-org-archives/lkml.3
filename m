Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaE0VRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:17:16 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49831 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaE0VRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:17:13 -0400
Date: Wed, 28 May 2014 00:16:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mitchel Humpherys <mitchelh@codeaurora.org>
Cc: Heesub Shin <heesub.shin@samsung.com>, devel@driverdev.osuosl.org,
        Sunghwan Yun <sunghwan.yun@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>, linux-kernel@vger.kernel.org,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>
Subject: Re: [PATCH 6/9] staging: ion: remove struct page_info
Message-ID: <20140527211652.GR15585@mwanda>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
 <1401098701-24049-6-git-send-email-heesub.shin@samsung.com>
 <vnkw61kr5aso.fsf@mitchelh-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vnkw61kr5aso.fsf@mitchelh-linux.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 11:36:07AM -0700, Mitchel Humpherys wrote:
> On Mon, May 26 2014 at 03:04:58 AM, Heesub Shin <heesub.shin@samsung.com> wrote:
> > -static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
> > -						 struct ion_buffer *buffer,
> > -						 unsigned long size,
> > -						 unsigned int max_order)
> > +static struct page *alloc_largest_available(struct ion_system_heap *heap,
> > +					    struct ion_buffer *buffer,
> > +					    unsigned long size,
> > +					    unsigned int max_order)
> 
> Was this whitespace-only change intentional?

Yes.  It's correct.

Heesub changed "page_info" to "page" and that forced a re-alignment of
the parameters.

regards,
dan carpenter

