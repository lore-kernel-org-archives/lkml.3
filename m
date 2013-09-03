Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab3ICGoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:44:12 -0400
Received: from purkki.adurom.net ([80.68.90.206]:58410 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab3ICGoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:44:11 -0400
X-Greylist: delayed 1715 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Sep 2013 02:44:10 EDT
From: Kalle Valo <kvalo@adurom.com>
To: Masami Ichikawa <masami256@gmail.com>
Cc: IvDoorn@gmail.com, gwingerde@gmail.com, helmut.schaa@googlemail.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add WLI-UC-G300HP's Product ID.
References: <1377617843-28835-1-git-send-email-masami256@gmail.com>
Date: Tue, 03 Sep 2013 09:15:33 +0300
In-Reply-To: <1377617843-28835-1-git-send-email-masami256@gmail.com> (Masami
	Ichikawa's message of "Wed, 28 Aug 2013 00:37:23 +0900")
Message-ID: <87txi2toqi.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Ichikawa <masami256@gmail.com> writes:

> Support Bufallo WLI-UC-G300HP.
>
> Signed-off-by: Masami Ichikawa <masami256@gmail.com>

Please add "rt2x00: " prefix to the commit title.

-- 
Kalle Valo
