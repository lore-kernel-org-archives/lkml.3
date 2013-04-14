Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab3DNIZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 04:25:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48146 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3DNIZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 04:25:51 -0400
Date: Sun, 14 Apr 2013 10:25:22 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 2/2] mtip32xx: mtip32xx: Disable TRIM support
Message-ID: <20130414082522.GE12244@kernel.dk>
References: <51685232.2040209@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51685232.2040209@micron.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12 2013, Asai Thambi S P wrote:
> 
> Temporarily disabling TRIM support until TRIM related issues
> are addressed in the firmware.

How serious is this? We do have released kernels out there with the
driver, you might want to consider a stable backport too.

Anyway, applied for 3.10.

-- 
Jens Axboe

