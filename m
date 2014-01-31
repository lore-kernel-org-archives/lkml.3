Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbaAaT52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:57:28 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:33677 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbaAaT51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:57:27 -0500
Date: Fri, 31 Jan 2014 21:56:46 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Surendra Patil <surendra.tux@gmail.com>
Cc: gregkh@linuxfoundation.org, devendra.aaru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging:octeon-usb: Fixed Bitfields coding style
 errors
Message-ID: <20140131195646.GD589@drone.musicnaut.iki.fi>
References: <1391152667-11587-1-git-send-email-surendra.tux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391152667-11587-1-git-send-email-surendra.tux@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 30, 2014 at 11:17:47PM -0800, Surendra Patil wrote:
> Fixed Below coding style errors -
> octeon-hcd.h:146: ERROR: spaces prohibited around that ':' (ctx:WxW)
> octeon-hcd.h:147: ERROR: spaces prohibited around that ':' (ctx:WxW)

Not an error, checkpatch is wrong here.

A.
