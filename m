Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbbAEJ36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:29:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56859 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbbAEJ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:29:56 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: stefano.brivio@polimi.it, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:net:wireless: Add proper locking for the function, b43_op_beacon_set_tim in main.c
References: <1420184041-6788-1-git-send-email-xerofoify@gmail.com>
Date: Mon, 05 Jan 2015 11:29:50 +0200
In-Reply-To: <1420184041-6788-1-git-send-email-xerofoify@gmail.com> (Nicholas
	Krause's message of "Fri, 2 Jan 2015 02:34:01 -0500")
Message-ID: <87tx05378x.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Krause <xerofoify@gmail.com> writes:

> This adds proper locking for the function, b43_op_beacon_set_tim in
> main.c by using the mutex lock in the structure pointer wl, as
> embedded into this pointer as a mutex in order to protect against
> multiple access to the pointer wl when updating the templates for this
> pointer in the function, b43_update_templates internally in the
> function, b43_op_beacon_set_tim.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Based on the discussion I have dropped this patch.

-- 
Kalle Valo
