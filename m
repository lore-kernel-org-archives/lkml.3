Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246Ab3D3K6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 06:58:30 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53942
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316Ab3D3K63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 06:58:29 -0400
Date: Tue, 30 Apr 2013 12:58:12 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, gregkh@linuxfoundation.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH] relay: move remove_buf_file inside relay_close_buf PING..
Message-ID: <20130430105812.GB7800@kernel.dk>
References: <87ppxnhu9r.fsf@openvz.org>
 <87y5c0mrad.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5c0mrad.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30 2013, Dmitry Monakhov wrote:
> On Mon, 22 Apr 2013 11:57:52 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> Non-text part: multipart/mixed
> > 
> Seriously. Am I an only one who use blktrace?

I do :-)

> Jens can you please take it?

Thanks, will do.

-- 
Jens Axboe

