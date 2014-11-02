Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaKBVzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 16:55:46 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:49782 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaKBVzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 16:55:45 -0500
Date: Sun, 2 Nov 2014 22:55:36 +0100
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Thomas Graf <tgraf@suug.ch>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@redhat.com>
Subject: Re: getaddrinfo slowdown in 3.17.1, due to getifaddrs
Message-ID: <20141102215536.GB29939@sesse.net>
References: <20141017002132.GA29584@sesse.net>
 <20141017003430.GB29584@sesse.net>
 <20141017062517.GA11584@casper.infradead.org>
 <20141021132557.GA9440@sesse.net>
 <20141021133144.GA8802@casper.infradead.org>
 <20141023233751.GA10504@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141023233751.GA10504@sesse.net>
X-Operating-System: Linux 3.16.3 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 01:37:51AM +0200, Steinar H. Gunderson wrote:
>> I'm currently testing the patch below and will submit with proper
>> tested by attributions later today.
> We applied this patch in a reboot today (on top of 3.17.1), and so far,
> things seem to be going much better.

I see 3.17.2 is out. Am I right in that this patch didn't make it?

/* Steinar */
-- 
Homepage: http://www.sesse.net/
