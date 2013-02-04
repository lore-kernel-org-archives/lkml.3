Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3BDNJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:09:31 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:40449 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab3BDNJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:09:30 -0500
Date: Mon, 4 Feb 2013 10:09:27 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, skinsbursky@parallels.com,
        rusty@rustcorp.com.au, jmorris@namei.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, linux-mtd@lists.infradead.org,
        ebiederm@xmission.com, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 37/62] mtd: convert to idr_alloc()
Message-ID: <20130204130926.GA16825@localhost>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-38-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1359854463-2538-38-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 05:20:38PM -0800, Tejun Heo wrote:
> Convert to the much saner new idr interface.
> 
> Only compile tested.
> 

Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
