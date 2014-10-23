Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaJWXiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:38:09 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:44861 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaJWXiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:38:07 -0400
Date: Fri, 24 Oct 2014 01:37:51 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Thomas Graf <tgraf@suug.ch>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@redhat.com>
Subject: Re: getaddrinfo slowdown in 3.17.1, due to getifaddrs
Message-ID: <20141023233751.GA10504@sesse.net>
References: <20141017002132.GA29584@sesse.net>
 <20141017003430.GB29584@sesse.net>
 <20141017062517.GA11584@casper.infradead.org>
 <20141021132557.GA9440@sesse.net>
 <20141021133144.GA8802@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141021133144.GA8802@casper.infradead.org>
X-Operating-System: Linux 3.16.3 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 02:31:44PM +0100, Thomas Graf wrote:
> I'm currently testing the patch below and will submit with proper
> tested by attributions later today.

We applied this patch in a reboot today (on top of 3.17.1), and so far,
things seem to be going much better.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
