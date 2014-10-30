Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbaJ3Qka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:40:30 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:59700 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879AbaJ3Qk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:40:28 -0400
Date: Thu, 30 Oct 2014 12:40:24 -0400
From: Shea Levy <shea@shealevy.com>
To: linux-aio@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: IOCB_CMD_SPLICE?
Message-ID: <20141030164024.GD11414@nixos.hsd1.nh.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Would it be possible/desirable to combine asynchronous IO with zero-copy
IO with something like IOCB_CMD_SPLICE for an async version of
splice(2)?

~Shea
