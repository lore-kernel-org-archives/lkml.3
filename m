Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaA2M70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 07:59:26 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:53735 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752321AbaA2M7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 07:59:25 -0500
Date: Wed, 29 Jan 2014 07:59:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        nicolas.dichtel@6wind.com, stable@vger.kernel.org, williams@redhat.com,
        lclaudio@uudg.org, jkacur@redhat.com
Subject: Re: [PATCH 0/2] [BUG FIXES - 3.10.27] sit: More backports
Message-ID: <20140129075923.7d105fde@gandalf.local.home>
In-Reply-To: <20140128.235214.881810600024309551.davem@davemloft.net>
References: <20140128205756.074448668@goodmis.org>
	<20140128.235214.881810600024309551.davem@davemloft.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014 23:52:14 -0800 (PST)
David Miller <davem@davemloft.net> wrote:


> Greg, these have my blessing, please apply these to 3.10 -stable,
> thanks a lot!

Hi David,

Thanks for the blessing :-) But I want to work with Nicolas a bit more
to make sure that I have a correct backport. Just because it fixed some
of our bugs doesn't mean that I didn't make new ones.

Thanks,

-- Steve
