Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3L1N5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 08:57:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab3L1N5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 08:57:14 -0500
Message-ID: <1388239027.5328.39.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.12.6-rt9
From: Mike Galbraith <bitbucket@online.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Sat, 28 Dec 2013 14:57:07 +0100
In-Reply-To: <20131228074331.GA26538@opentech.at>
References: <20131223225017.GA8623@linutronix.de>
	 <20131227200024.GA19505@opentech.at>
	 <1388201449.5387.70.camel@marge.simpson.net>
	 <1388202516.5387.79.camel@marge.simpson.net>
	 <20131228074331.GA26538@opentech.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:QaOBpfyTUHBO9slTI5DEm4bOX4V5YeWcwp5oqJqvB2Z
 TseD25lK31Fy/9fwZp6f1tcA1w3OogbueyO+VYVVafryg6vE5N
 CLFixvmdfnJ8IldnZrILiXimUBJNr819tG5mwWhKlJgExeWK1z
 1KBOfxPzvUMowjNsKHGTqsBcIAhupI5ehT2f5XPCC5Mc7eBE70
 NKTDfEfUpu5eqTUahxSBoF6DvtmzEX5Bd4fmWbKGrzgRh4ji6E
 u8MdvvDiEcOVb96H7GMAnGr8gsA/QBmvkTX5LLRGDNWU9EP8cS
 i3yYZ9MPg1hMYIEGO70P/eUtu1uBwWy6N9NhkwpmnYYLgDw6TW
 ez6H1EQ6y3BTnIxyu1zqeeDp50CpG3HFR1y4QggX0+PR0srcSj
 ETLqZ5jnIfRPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-28 at 08:43 +0100, Nicholas Mc Guire wrote:

> This type of blowups will not help to go mainline (refereing to 3.12.X here, 
> 3.4/6/8/10 is a different story).

Nah.  Breakage is a vital sign.  When breakage stops, bury it.

-Mike

