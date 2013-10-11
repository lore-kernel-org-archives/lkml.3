Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3JKO15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:27:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39248 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3JKO14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:27:56 -0400
Message-ID: <52580AAF.5010809@kernel.dk>
Date: Fri, 11 Oct 2013 08:26:55 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] null_blk: fix a bug in capacity calculation
References: <20131011041428.GB1692@kernel.org>
In-Reply-To: <20131011041428.GB1692@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 10:14 PM, Shaohua Li wrote:
> the capacity calculation is obvious buggy.

Thanks, applied.


-- 
Jens Axboe

