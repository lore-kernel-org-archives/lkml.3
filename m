Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbaAaLtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 06:49:14 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34933 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932143AbaAaLtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 06:49:13 -0500
X-Sasl-enc: r18XvILiy+lA4sSs3FM8e/HHQPdQqBzTQB4ZZ88laWU7 1391168952
Message-ID: <52EB8DB7.5010104@iki.fi>
Date: Fri, 31 Jan 2014 13:49:11 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Fabio Estevam <festevam@gmail.com>
CC: penberg@kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Warning at mm/slub.c
References: <CAOMZO5ASeLoa3s2PqaPqA-zd83hc8qQCHyfedP+KEzvitBpqog@mail.gmail.com> <20140124142112.GA30183@twins.programming.kicks-ass.net>
In-Reply-To: <20140124142112.GA30183@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 04:21 PM, Peter Zijlstra wrote:
> Dave Hansen already send a fix for that:
>
> lkml.kernel.org/r/52D5746F.2040604@intel.com
>
>
>
> Pekka, any chance to get that merged?

Sorry for the delay - I'm way behind my inbox.

It's applied now, thanks!

                     Pekka
