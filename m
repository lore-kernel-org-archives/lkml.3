Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3AUI7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:59:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28762 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3AUI7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:59:30 -0500
Date: Mon, 21 Jan 2013 11:58:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, Prarit Bhargava <prarit@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [patch] module: potential deadlock in error path
Message-ID: <20130121085836.GU16282@mwanda>
References: <20130118074309.GB31793@elgon.mountain>
 <87ip6rwcvz.fsf@rustcorp.com.au>
 <CA+55aFzEkSOWL13cX2xaYttPF5=Qpvya9Yapk-RC8KQ5=QJk+w@mail.gmail.com>
 <87vcarur8n.fsf@rustcorp.com.au>
 <CA+55aFyhfuLJqsEiAJ3jyf_OikgZroFkfBW1i-LYwCr0YOVX1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyhfuLJqsEiAJ3jyf_OikgZroFkfBW1i-LYwCr0YOVX1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty, you have this right?  I like Linus's version.  Could you give
me a Reported-by tag?

regards,
dan carpenter

