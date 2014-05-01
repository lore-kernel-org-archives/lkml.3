Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaEAWlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:41:40 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:39173 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaEAWlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:41:39 -0400
Date: Fri, 2 May 2014 00:41:38 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Udo <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: r8169 Rx ERROR.
Message-ID: <20140501224138.GA21249@electric-eye.fr.zoreil.com>
References: <201404300650.s3U6oFU8030981@surfplank2.hierzo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201404300650.s3U6oFU8030981@surfplank2.hierzo>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo <udovdh@xs4all.nl> :
[...]
> [354436.656703] r8169 0000:01:00.0 eth0: Rx ERROR. status = 342ac40d
> [354615.387915] r8169 0000:01:00.0 eth0: Rx ERROR. status = 342cc075
> (and a load more of them)
> 
> What is wrong? Hardware?

Ethernet CRC is wrong.

Which kind of 816x is it (see XID in kernel log) ?

-- 
Ueimor
