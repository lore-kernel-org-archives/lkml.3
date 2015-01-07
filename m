Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbbAGRwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:52:47 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42684 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbbAGRwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:52:45 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Fred Chou <fred.chou.nd@gmail.com>
Cc: sgruszka@redhat.com, helmut.schaa@googlemail.com,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: rt2x00: use helper to check capability/requirement
References: <1419581958-5927-1-git-send-email-fred.chou.nd@gmail.com>
Date: Wed, 07 Jan 2015 19:52:38 +0200
In-Reply-To: <1419581958-5927-1-git-send-email-fred.chou.nd@gmail.com> (Fred
	Chou's message of "Fri, 26 Dec 2014 16:19:18 +0800")
Message-ID: <87k30yqxzt.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fred Chou <fred.chou.nd@gmail.com> writes:

> From: Fred Chou <fred.chou.nd@gmail.com>
>
> Use rt2x00_has_cap_flag macro to check rt2x00dev->cap_flags. 
>
> Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>

Thanks, applied to wireless-drivers-next.git. But I simplified the
title:

b9d305cc4740 rt2x00: use helper to check capability/requirement

-- 
Kalle Valo
