Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaAQF1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 00:27:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49440 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbaAQF1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 00:27:16 -0500
Message-ID: <52D8BF2C.9090604@zytor.com>
Date: Thu, 16 Jan 2014 21:27:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linux-Sparse <linux-sparse@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: gcc tickets for sparse attributes
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have filed gcc tickets asking for direct support in gcc for some
sparse extensions that we use heavily in the kernel:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59850
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59851

However, I would also like support for the context extensions, but I'm
not knowledgeable enough to describe the semantics accurately.  Would
anyone be willing to file a ticket describing how the context extension
works well enough that it could be implemented?

	-hpa
