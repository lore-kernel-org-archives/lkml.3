Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaBNQPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:15:53 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:33436 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaBNQPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:15:52 -0500
Date: Fri, 14 Feb 2014 08:15:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: man-pages-3.58 is released
Message-ID: <20140214161552.GA20909@infradead.org>
References: <52FE33A0.6090702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FE33A0.6090702@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 04:17:52PM +0100, Michael Kerrisk (man-pages) wrote:
> pipe.2
>     Michael Kerrisk
>         Document the pipe2() O_DIRECT flag added in Linux 3.4

Eww, reusing O_DIRECT for some totally different semantics is nasty.
Did this go by linux-man back in the day?

