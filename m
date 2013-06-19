Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934184Ab3FSIhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:37:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60462 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755Ab3FSIhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:37:36 -0400
Date: Wed, 19 Jun 2013 01:37:31 -0700 (PDT)
Message-Id: <20130619.013731.2219938413280120274.davem@davemloft.net>
To: steve.moorby@ntlworld.com
Cc: jiri@resnulli.us, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/net: param for lapbether for specific
 ethernet device
From: David Miller <davem@davemloft.net>
In-Reply-To: <51C16A07.3070903@ntlworld.com>
References: <51C16A07.3070903@ntlworld.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please no module parameters, provide a run-time, programmatic way
to configure this aspect.
