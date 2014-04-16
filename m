Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaDPT5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:57:32 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47086 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaDPT5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:57:30 -0400
Date: Wed, 16 Apr 2014 20:56:44 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 21/21] misc: support for I-8024 in LP-8x4x
Message-ID: <20140416205644.396709aa@alan.etchedpixels.co.uk>
In-Reply-To: <9eb6a7ac-e8c0-4c05-8f8a-e047d2614cba@email.android.com>
References: <1397668411-27162-7-git-send-email-ynvich@gmail.com>
	<1397668667-27328-1-git-send-email-ynvich@gmail.com>
	<1397668667-27328-15-git-send-email-ynvich@gmail.com>
	<20140416193949.47f4ea68@alan.etchedpixels.co.uk>
	<9eb6a7ac-e8c0-4c05-8f8a-e047d2614cba@email.android.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've closely examined a dozen or two of drivers, but of them was close enough for I-8024 in terms of speed. Its channel takes 0.1 us to set up from kernel. Real user space programs can setup all for channels in 1 us with interface provided by this patch. That's said I don't have data on time that it takes for output to stabilize at the desired levels.
> 
> I've chosen drivers/misc as a location that looked to provide the shortest path for my driver to land. The driver needs support for the bus, and here it can be in one driver.
> 
> It would be great to have some more detailed input on this issue.

IIO is where we are trying to standardise all the industrial control
devices. There is stuff in places like misc for historical reasons.

