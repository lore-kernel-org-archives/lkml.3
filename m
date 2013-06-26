Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab3FZG2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:28:51 -0400
Received: from science.horizon.com ([71.41.210.146]:24037 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751444Ab3FZG2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:28:50 -0400
Date: 26 Jun 2013 02:28:48 -0400
Message-ID: <20130626062848.32620.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: gaofeng@cn.fujitsu.com, pablo@netfilter.org
Subject: Re: v3.10-rc7 oops soon after boot
Cc: bp@alien8.de, kaber@trash.net, linux-kernel@vger.kernel.org,
        linux@horizon.com, netfilter@vger.kernel.org
In-Reply-To: <20130624113441.GA2583@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have mangled your patch, find it attached.

I'm sure it's not a surprise, but just for the record, I can now confirm
that this fixes my crash, too.
