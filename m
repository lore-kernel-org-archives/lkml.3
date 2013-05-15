Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab3EOIFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:05:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54996 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab3EOIFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:05:37 -0400
Date: Wed, 15 May 2013 10:04:51 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Sam Bradshaw <sbradshaw@micron.com>
Cc: linux-kernel@vger.kernel.org, asamymuthupa@micron.com
Subject: Re: [PATCH][TRIVIAL] mtip32xx: Fix NULL pointer dereference during
 module unload
Message-ID: <20130515080451.GA3276@kernel.dk>
References: <5192B209.1010301@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5192B209.1010301@micron.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14 2013, Sam Bradshaw wrote:
> An open file-handle to one or more of the driver exported debugfs
> nodes causes raciness in recursive removal during module unload;
> sometimes a stale parent dentry is dereferenced when more than 1
> pci device is present.

Thanks applied, I hit this one too recently.

-- 
Jens Axboe

