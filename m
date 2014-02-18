Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaBRUU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:20:59 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:44553 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaBRUU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:20:57 -0500
Date: Tue, 18 Feb 2014 12:20:54 -0800
From: Jens Axboe <axboe@kernel.dk>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT pull] DRBD code reorganization
Message-ID: <20140218202054.GD25515@kernel.dk>
References: <1426530.nXFczoq90f@fat-tyre>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1426530.nXFczoq90f@fat-tyre>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17 2014, Philipp Reisner wrote:
> Hi Jens,
> 
> I have here a number of patches, that do not change any functionality.
> All patches from Rashika Kheria clean up compiler warnings, like making
> functions static etc... . All patches from Andreas Grünbacher restructure
> code for further improvements. A single bugfix is hidden in there, that
> was committed by me.
> 
> Rashika patches where posted for review on LKML on December 19, 2013.
> The other patches where posted for review on LKML on December 20 and 23.
> 
> This is of course for your tree that is intended for the 3.15 merge window.
> Since you have not created a for-3.15/drivers branch as of today, I based
> this on Linus' 2.14-rc3.

Pulled into a for-3.15/drivers branch.

-- 
Jens Axboe

