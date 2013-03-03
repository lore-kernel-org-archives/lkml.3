Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3CCPgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 10:36:35 -0500
Received: from mail.gnuher.de ([78.47.12.54]:44155 "EHLO mail.gnuher.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab3CCPge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 10:36:34 -0500
Date: Sun, 3 Mar 2013 16:36:25 +0100
From: Sven Geggus <lists@fuchsschwanzdomain.de>
To: Marcin Jurkowski <marcin1j@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] w1: fix oops when w1_search is called from netlink
 connector
Message-ID: <20130303153625.GA14858@geggus.net>
References: <20130116141627.GA23638@ioremap.net>
 <20130302001103.GB18026@gmail.com>
 <20130302094510.GA4695@geggus.net>
 <20130302135015.GA21448@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130302135015.GA21448@gmail.com>
X-MimeOLE: Produced By Exchange Microsoft V6.6.6
User-Agent: Mutt/1.5.21 (2010-09-15)
X-remote-host: diesel.geggus.net [2a01:198:297:1:21c:c0ff:fefa:8a7b]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Jurkowski schrieb am Samstag, den 02. März um 14:50 Uhr:

> This patch adds a check if w1_search is serving netlink command, skipping
> kthread_should_stop invocation if so.

Works fine on my Raspberry Pi!

Any chance to get this fix into mainline?

Regards

Sven

-- 
# Turn on/off security.  Off is currently the default
(found in MongoDB default configfile)

/me is giggls@ircnet, http://sven.gegg.us/ on the Web
