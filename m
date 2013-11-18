Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3KRVWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 16:22:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50083 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3KRVWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 16:22:21 -0500
Date: Mon, 18 Nov 2013 16:22:19 -0500 (EST)
Message-Id: <20131118.162219.1206321207733675662.davem@davemloft.net>
To: zwu.kernel@gmail.com
Cc: netdev@vger.kernel.org, mst@redhat.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] vhost: remove the dead branch
From: David Miller <davem@davemloft.net>
In-Reply-To: <1384780716-25433-1-git-send-email-zwu.kernel@gmail.com>
References: <1384780716-25433-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 18 Nov 2013 13:22:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These two patches are cleanups, please resubmit them after the merge
window closes and the net-next tree opens back up.

Thank you.
