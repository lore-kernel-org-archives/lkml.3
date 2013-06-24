Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3FXIrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:47:33 -0400
Received: from science.horizon.com ([71.41.210.146]:51980 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751917Ab3FXIr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:47:29 -0400
Date: 24 Jun 2013 04:47:27 -0400
Message-ID: <20130624084727.1494.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: bp@alien8.de
Subject: Re: v3.10-rc7 oops soon after boot
Cc: kaber@trash.net, linux-kernel@vger.kernel.org, linux@horizon.com,
        netfilter@vger.kernel.org, pablo@netfilter.org
In-Reply-To: <20130624073340.GA26787@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This looks like ulog_timer in net/ipv4/netfilter/ipt_ULOG.c, judging by
> your config.

Ah, yes, it's a firewall/router machine with multiple interfaces.
Exploding based on packet arrivals could explain the variable timing
during init script processing.

Thank you!
