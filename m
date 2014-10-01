Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaJAWeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:34:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37463 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaJAWer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:34:47 -0400
Date: Wed, 01 Oct 2014 18:34:45 -0400 (EDT)
Message-Id: <20141001.183445.1800881550207439817.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, gerrit@erg.abdn.ac.uk, dccp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] net/dccp/ccid.c: add __init to
 ccid_activate
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412139126-3794-1-git-send-email-fabf@skynet.be>
References: <1412139126-3794-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Oct 2014 15:34:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Wed,  1 Oct 2014 06:52:06 +0200

> ccid_activate is only called by __init ccid_initialize_builtins in same module.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
