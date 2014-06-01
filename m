Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaFARmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 13:42:09 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:41150 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaFARmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 13:42:07 -0400
Date: Sun, 1 Jun 2014 19:42:05 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 3.14.1 network issue with rtl81xx chip
Message-ID: <20140601174205.GA2027@electric-eye.fr.zoreil.com>
References: <538B2502.5070707@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538B2502.5070707@xs4all.nl>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel <udovdh@xs4all.nl> :
[...]
> On two boxes with rtl network chip I see connections going down.

Do you notice netdev watchdog messages in the kernel log ?

[...]
> 3.14.1 has the issue.

Does it qualify as a (recent ?) regression or is it a fresh new setup ?

> How can I fix this more elegantly ?

No suggestion yet.

-- 
Ueimor
