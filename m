Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab3EHUQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:16:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41821 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab3EHUQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:16:23 -0400
Date: Wed, 08 May 2013 13:16:22 -0700 (PDT)
Message-Id: <20130508.131622.793679021804441217.davem@davemloft.net>
To: jwboyer@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, pwouters@redhat.com
Subject: Re: [PATCH] if_cablemodem.h: Add parenthesis around ioctl macros
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130508194547.GE16269@hansolo.jdub.homelinux.org>
References: <20130508194547.GE16269@hansolo.jdub.homelinux.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 08 May 2013 13:16:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>
Date: Wed, 8 May 2013 15:45:47 -0400

> Protect the SIOCGCM* ioctl macros with parenthesis.
> 
> Reported-by: Paul Wouters <pwouters@redhat.com>
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>

Applied and queued up for -stable.
