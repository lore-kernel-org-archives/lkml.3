Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3AKK2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 05:28:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48931 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab3AKK2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 05:28:02 -0500
Message-ID: <50EFE92C.4080209@kernel.dk>
Date: Fri, 11 Jan 2013 11:27:56 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Danny Kukawka <danny.kukawka@bisect.de>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] dac960: return success instead of -ENOTTY
References: <20130111065244.GD13207@elgon.mountain>
In-Reply-To: <20130111065244.GD13207@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-11 07:52, Dan Carpenter wrote:
> There is a missing break statement here.  This used to return directly
> but we re-worked it in 2008 to add locking as part of the BKL push down.

Thanks Dan, applied. Must have a big user base...

-- 
Jens Axboe

