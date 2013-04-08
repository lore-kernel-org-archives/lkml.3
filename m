Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935767Ab3DHTeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:34:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2282 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935736Ab3DHTeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:34:10 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=h0Bao8ck8UcA:10 a=5SG0PmZfjMsA:10 a=NQU6wFvwlmQA:10 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=SfN2wQenpQEA:10 a=8RXYMDzl5hmIUjSzsJsA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365449648.25498.28.camel@gandalf.local.home>
Subject: Re: WRONG files in
 https://www.kernel.org/pub/linux/kernel/projects/rt/3.4/
From: Steven Rostedt <rostedt@goodmis.org>
To: Martin Bohun <martin.bohun@gmail.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        stable-rt@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Mon, 08 Apr 2013 15:34:08 -0400
In-Reply-To: <CAGVz94ht0Y37Ai0r5bJNxSM_EjOw2N4HTSRssK37geAnVfPrwg@mail.gmail.com>
References: <CAGVz94ht0Y37Ai0r5bJNxSM_EjOw2N4HTSRssK37geAnVfPrwg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 13:58 +1100, Martin Bohun wrote:
> The https://www.kernel.org/pub/linux/kernel/projects/rt/3.4/ contains
> WRONG (3.2, not 3.4) files/patches,

Yep, I screwed up the patch pushing as I rushed to get them released
before I went on vacation. It should be all fixed now.

-- Steve



