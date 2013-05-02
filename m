Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab3EBIAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:00:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:38536 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3EBIAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:00:03 -0400
Message-ID: <51821CFC.3050503@linutronix.de>
Date: Thu, 02 May 2013 09:59:56 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Clark Williams <williams@redhat.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, rostedt@goodmis.org
Subject: Re: Suspend resume problem (WAS Re: [ANNOUNCE] 3.8.10-rt6)
References: <20130429201202.GB7979@linutronix.de> <20130429161925.2a6ea78a@riff.lan> <20130430170948.GB4688@linutronix.de> <20130430223105.GA12385@pd.tnic>
In-Reply-To: <20130430223105.GA12385@pd.tnic>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 12:31 AM, Borislav Petkov wrote:
> Didn't tlgx fix a similar issue upstream already?
> 
> 77c675ba18836.

He did as it seems.

Sebastian
