Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaJAUfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:35:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36458 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJAUfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:35:14 -0400
Date: Wed, 01 Oct 2014 16:35:12 -0400 (EDT)
Message-Id: <20141001.163512.902486975602548782.davem@davemloft.net>
To: sylvain.hitier@gmail.com
Cc: linux-kernel@vger.kernel.org, nhorman@tuxdriver.com, mroos@linux.ee
Subject: Re: [PATCH v3] 3c59x: fix bad split of
 cpu_to_le32(pci_map_single())
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140929210132.GD15737@erable>
References: <20140929210132.GD15737@erable>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Oct 2014 13:35:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Networking patches need to be at least CC:'d to netdev@vger.kernel.org

Thank you.
