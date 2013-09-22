Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3IVVm5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:42:57 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:44543 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab3IVVmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:42:55 -0400
Date: Sun, 22 Sep 2013 17:42:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_isapnp: Don't use invalid I/O ports
Message-ID: <20130922214250.GA27616@mtj.dyndns.org>
References: <1379019689-21467-1-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379019689-21467-1-git-send-email-linux@rainbow-software.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 11:01:29PM +0200, Ondrej Zary wrote:
> The test for 2nd I/O port validity is broken (reversed):
> On devices with no control port, the driver attempts to use invalid port 0,
> resulting in logs full of bad_io_access errors.
> On devices with control port, the driver does not use it.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Applied to libata/for-3.13.

Thanks.

-- 
tejun
