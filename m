Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaHLSVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:21:11 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:40439 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaHLSVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:21:09 -0400
MIME-Version: 1.0
In-Reply-To: <1407828913-7461-1-git-send-email-sanjeev_sharma@mentor.com>
References: <1407828913-7461-1-git-send-email-sanjeev_sharma@mentor.com>
Date: Tue, 12 Aug 2014 13:21:08 -0500
Message-ID: <CAPp3RGq=0dgWKmaf5pgNfkKZX=Wy99=QPm-Fs0sDgi7a0hir0g@mail.gmail.com>
Subject: Re: [PATCH] sgi-xp: Do not use BUG_ON(!spin_is_locked())
From: Robin Holt <robinmholt@gmail.com>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: "Cliff Wickman (SGI)" <cpw@sgi.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 2:35 AM, Sanjeev Sharma
<sanjeev_sharma@mentor.com> wrote:
> on some architecture spin_is_locked() always return false in
> uniprocessor configuration and can therefore not be used
> with BUG_ON.it would be advise to replace with
> lockdep_assert_held().
>
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Acked-by: Robin Holt <robinmholt@gmail.com>
