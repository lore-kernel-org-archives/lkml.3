Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbbAWTeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:34:37 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43687 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbbAWTee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:34:34 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wireless: p54: add handling of the signal case
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1421731543-13290-1-git-send-email-der.herr@hofr.at>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Message-Id: <20150123193434.5F4AA141E7F@smtp.codeaurora.org>
Date: Fri, 23 Jan 2015 19:34:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> if(!wait_for_completion_interruptible_timeout(...))
> only handles the timeout case - this patch adds handling the
> signal case the same as timeout.
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> Acked-by: Christian Lamparter <chunkeey@googlemail.com>

Thanks, applied to wireless-drivers-next.git but I removed "wireless:" from the
title.

Kalle Valo
