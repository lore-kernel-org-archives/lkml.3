Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab3CSU0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:26:16 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:62962 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757266Ab3CSU0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:26:14 -0400
Message-ID: <1363724768.1390.36.camel@x61.thuisdomein>
Subject: Re: [PATCH] sparc: remove unused "config BITS"
From: Paul Bolle <pebolle@tiscali.nl>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 21:26:08 +0100
In-Reply-To: <20130319201454.GA25072@merkur.ravnborg.org>
References: <1363708727.1390.16.camel@x61.thuisdomein>
	 <20130319.123306.1709006318806942163.davem@davemloft.net>
	 <1363712807.1390.26.camel@x61.thuisdomein>
	 <20130319201454.GA25072@merkur.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Mar 2013 20:26:08.0853 (UTC) FILETIME=[FD6ED850:01CE24DF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 21:14 +0100, Sam Ravnborg wrote:
> On Tue, Mar 19, 2013 at 06:06:47PM +0100, Paul Bolle wrote:
> > So $(BITS) is set depending on whether CONFIG_SPARC32 is set or not.
> > Using $(BITS) in sparc's Makefiles is not using CONFIG_BITS. That
> > doesn't count as usage of "config BITS". 
> Just double checked - you are right.

Thanks.

> Maybe send a v2 with this info in changelog and add my:
> 
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

David: should I send a second version with a line or two on the
(non-related) use of BITS in the Makefiles and Sam's ACK?


Paul Bolle

