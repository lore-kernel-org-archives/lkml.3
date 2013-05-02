Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850Ab3EBRyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:54:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34357 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759622Ab3EBRye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:54:34 -0400
Message-ID: <5182A850.5010905@zytor.com>
Date: Thu, 02 May 2013 10:54:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: modpost command line still is a problem
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least as far as current linus, "make allmodconfig" still fails with
O= in a sufficiently deep directory due to the modpost command line
being too long.

There was a bunch of talk about how to address that, but did anything
ever come of it?

	-hpa
