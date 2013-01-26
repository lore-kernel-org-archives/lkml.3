Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab3AZApl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 19:45:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49807 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3AZApj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 19:45:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 19/19] [INCOMPLETE] ARM: make return_address available for ARM_UNWIND
Date: Sat, 26 Jan 2013 00:45:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: Dave Martin <dave.martin@linaro.org>, Steven Rostedt <rostedt@goodmis.org>,
        sahara <keun-o.park@windriver.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359132254.21576.230.camel@gandalf.local.home> <20130125165934.GE2069@linaro.org>
In-Reply-To: <20130125165934.GE2069@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301260045.28804.arnd@arndb.de>
X-Provags-ID: V02:K0:x6vXjyQU7YS8Y0SqsqudKv/oy1OXOPxP7CtbavsHWMm
 Lpr/VmhTLKunDyIE4Hm2M/69/ntNdu0zb7SBszg/V86pWS6PdA
 L0UFJtMv5SissDk+8pNL0cMyekLcxBv9owjrgCHvZxfVMdbeSD
 bhrbZFiQSp2Gw0l98UK8I8sB9IziPots4xwk0ypwg0I8gI13Gi
 D4ADsNGUuH1vRcj/bDfUAPPcUWltGL+phmj4IqHaGKCNbuSjPE
 zfUdiMRFIIaJqr2S0MQ6Ux3sFdZChVZ3U9pfuGBoz3vxwtLZCB
 j32q1PMAry73/EWiiqUDWsgQKz/WLRfricEWxPgW9EgQcLiX0t
 V/ncd9gZWmSj+4OOT3/s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2013, Dave Martin wrote:
> On Fri, Jan 25, 2013 at 11:44:14AM -0500, Steven Rostedt wrote:
> > [ I got an error with linux-arm-kernel@list.infradead.org and had to
> > remove from CC ]
> 
> Blame Arnd :)
>

Sorry about that, I now posted the entire series again with the right
mailing list address.

	ARnd
