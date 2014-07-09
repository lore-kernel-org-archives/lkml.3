Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbaGIXn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:43:27 -0400
Received: from message.mylangara.bc.ca ([142.35.159.25]:49982 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbaGIXn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:43:26 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Message-id: <fb46c0d9691c.53bdd39d@langara.bc.ca>
Date: Wed, 09 Jul 2014 23:43:25 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: Re: [PATCH 1/1] include/uapi: Define AT_FDNODIR constant as future
 guarantee
X-Accept-Language: en
In-reply-to: <20140708121229.GA21107@infradead.org>
References: <fb469d6277ef.53b85737@langara.bc.ca>
 <20140708121229.GA21107@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the criticisms Christopher Hellwig.

I will edit the commit message to be better and comments in the code
to be clearer. I will also document the constant in the manpages. I
think I will call the constant AT_FDABSOLUTE though because I want it
to be prepended with FD the same way AT_FDCWD is.

Thank you,
Steven Stewart-Gallus
