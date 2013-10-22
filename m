Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab3JVGPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 02:15:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48968 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3JVGPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 02:15:48 -0400
Date: Tue, 22 Oct 2013 02:15:46 -0400 (EDT)
Message-Id: <20131022.021546.1648298758048784147.davem@davemloft.net>
To: freddy@asix.com.tw
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, allan@asix.com.tw, louis@asix.com.tw
Subject: Re: [PATCH 1/1] [PATCH resubmit] ax88179_178a: Correct the RX
 error definition in RX header
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382406449-2041-1-git-send-email-freddy@asix.com.tw>
References: <1382406449-2041-1-git-send-email-freddy@asix.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 21 Oct 2013 23:15:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Submit these, not individually as single patches, but as a patch set,
the first one with subject "[PATCH 1/2]" and the second with
subject "[PATCH 2/2]"

You have to do this, because it is absolutely essentially to let
me know which patch gets applies first and which one gets applied
second.  The two patches are to the same file, so if you don't
tell me the order, they won't apply cleanly at all.
