Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbbAFXRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:17:31 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:47320 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbbAFXRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:17:30 -0500
Date: Tue, 6 Jan 2015 18:17:27 -0500
From: Tejun Heo <tj@kernel.org>
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue.h: remove loops of single statement macros
Message-ID: <20150106231727.GD24106@htj.dyndns.org>
References: <1420561769-28068-1-git-send-email-valentinrothberg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420561769-28068-1-git-send-email-valentinrothberg@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 05:29:29PM +0100, Valentin Rothberg wrote:
> checkpatch.pl complained about two single statement macros in
> do while (0) loops.  The loops and the trailing semicolons are
> now removed, which makes checkpatch happy and the two macros
> consistent with the rest of the file.
> 
> Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>

Applied to wq/for-3.20.

Thanks.

-- 
tejun
