Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3FXXbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:31:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48185 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3FXXbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:31:24 -0400
Date: Mon, 24 Jun 2013 16:31:23 -0700 (PDT)
Message-Id: <20130624.163123.1868285609724163842.davem@davemloft.net>
To: wedsonaf@gmail.com
Cc: sergei.shtylyov@cogentembedded.com, tgraf@suug.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [NET]: Unmap fragment page once iterator is done
From: David Miller <davem@davemloft.net>
In-Reply-To: <CANeycqrPeBvOQeSmRZGcJwCvW=W=Hr+QW8O-99TB_Cqpv5Qr_Q@mail.gmail.com>
References: <1372055628-27044-1-git-send-email-wedsonaf@gmail.com>
	<51C820E7.6040004@cogentembedded.com>
	<CANeycqrPeBvOQeSmRZGcJwCvW=W=Hr+QW8O-99TB_Cqpv5Qr_Q@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wedson Almeida Filho <wedsonaf@gmail.com>
Date: Mon, 24 Jun 2013 15:47:18 -0700

> The summary line of the original commit is "[NET]: Zerocopy sequential
> reading of skb data".

He's telling you to put this in the commit message, and resubmit
the patch.
