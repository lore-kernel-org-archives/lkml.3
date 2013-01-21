Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3AUWei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:34:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43759 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3AUWeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:34:37 -0500
Date: Mon, 21 Jan 2013 17:34:34 -0500 (EST)
Message-Id: <20130121.173434.1226195006313740040.davem@davemloft.net>
To: richm@oldelvet.org.uk
Cc: dinggnu@gmail.com, sam@ravnborg.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] sparc: kernel/sbus.c: fix memory leakage
From: David Miller <davem@davemloft.net>
In-Reply-To: <50FDBF34.4020409@oldelvet.org.uk>
References: <50F7EED3.1050309@oldelvet.org.uk>
	<20130117132843.GD25615@gmail.com>
	<50FDBF34.4020409@oldelvet.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Mortimer <richm@oldelvet.org.uk>
Date: Mon, 21 Jan 2013 22:20:36 +0000

> Reviewed-by: Richard Mortimer <richm@oldelvet.org.uk>
> 
> On 17/01/2013 13:28, Cong Ding wrote:
>> The variable iommu and strbuf are not freed properly if it goes to
>> error.
>>
>> Signed-off-by: Cong Ding <dinggnu@gmail.com>

Applied, thanks everyone.
