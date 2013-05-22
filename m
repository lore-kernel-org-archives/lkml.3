Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab3EVV2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:28:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44592 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3EVV2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:28:49 -0400
Date: Wed, 22 May 2013 14:28:47 -0700 (PDT)
Message-Id: <20130522.142847.791230763817666795.davem@davemloft.net>
To: luto@amacapital.net
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, trinity@vger.kernel.org
Subject: Re: [PATCH 0/5] x86: oops on uaccess faults outside of user
 addresses
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1369177867.git.luto@amacapital.net>
References: <cover.1369177867.git.luto@amacapital.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please don't mix networking and non-networking changes into a patch
series.

Submit the networking patch to netdev@vger.kernel.org

Thanks.
