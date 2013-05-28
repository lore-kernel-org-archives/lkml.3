Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab3E1IT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:19:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933327Ab3E1IT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:19:27 -0400
Date: Tue, 28 May 2013 10:19:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Colin Leitner <colin.leitner@googlemail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: driver for PS2/3 Buzz controllers
In-Reply-To: <1369690865.2369.5.camel@roadrunner.fritz.box>
Message-ID: <alpine.LNX.2.00.1305281018250.3914@pobox.suse.cz>
References: <1369587150.4240.4.camel@roadrunner.fritz.box>  <alpine.LNX.2.00.1305271628540.3914@pobox.suse.cz> <1369690865.2369.5.camel@roadrunner.fritz.box>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 May 2013, Colin Leitner wrote:

> This patch adds support for PS2/3 Buzz controllers into hid-sony

Thanks, now applied.

As a followup, I think I'll merge hid-ps3remote into hid-sony as well.

-- 
Jiri Kosina
SUSE Labs
