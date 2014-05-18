Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaERTNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 15:13:15 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:44592 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570AbaERTNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 15:13:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjAhAB4FeVNXQCu6/2dsb2JhbABZgwaCQn2nOQEBAQEBAQUBmiUCAgEBAYEKF3SCJQEBBAEnExwjBQsIA0Y5HgYTiDkMAdETF4VViHsHhEABA5lZAYsRiAmDOTsw
Date: Sun, 18 May 2014 21:13:10 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] FS/HPFS: convert printk to pr_foo()
Message-Id: <20140518211310.cfb74b65a9b0e58500cae719@skynet.be>
In-Reply-To: <alpine.DEB.2.02.1405171845490.8869@artax.karlin.mff.cuni.cz>
References: <20140515191630.d982874c8318d427fdc560c0@skynet.be>
	<alpine.DEB.2.02.1405171845490.8869@artax.karlin.mff.cuni.cz>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2014 18:47:09 +0200 (CEST)
Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz> wrote:

> They are all (except commented printks) rather serious filesystem errors, 
> so you should use at least pr_err.
> 
> Mikulas

Ok, I'll send pr_warn->pr_err patch based on linux-next

Fabian
