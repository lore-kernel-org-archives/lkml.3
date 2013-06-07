Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab3FGSqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:46:31 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:50807 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3FGSq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:46:29 -0400
Date: Fri, 7 Jun 2013 20:46:22 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Pravin B Shelar <pshelar@nicira.com>
Subject: Re: NULL pointer dereference when loading the gre module (3.10.0-rc4)
Message-ID: <20130607184622.GA24906@uio.no>
References: <20130607030648.GA28618@home.goodmis.org>
 <20130607085421.GF15083@uio.no>
 <1370612441.24311.411.camel@edumazet-glaptop>
 <1370618100.9844.73.camel@gandalf.local.home>
 <20130607154634.GA7529@uio.no>
 <1370621543.9844.78.camel@gandalf.local.home>
 <20130607175233.GA20230@uio.no>
 <1370629568.9844.87.camel@gandalf.local.home>
 <20130607183438.GA23064@uio.no>
 <1370630659.9844.89.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1370630659.9844.89.camel@gandalf.local.home>
X-Operating-System: Linux 3.9.0+sesse01 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 02:44:19PM -0400, Steven Rostedt wrote:
> Do know if you have CONFIG_NET_NS set in your .config?

Sorry, I forgot to answer this: No, it is not set.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
