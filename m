Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab3FFIkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:40:06 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9905 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab3FFIkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:40:04 -0400
X-Spam-Score: -100.8
Message-ID: <51B04AB2.1020401@asianux.com>
Date: Thu, 06 Jun 2013 16:39:14 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/irq/irqdomain.c: before use 'irq_data', need check
 it whether valid.
References: <519219D5.6010907@asianux.com> <20130605224147.584263E10E4@localhost>
In-Reply-To: <20130605224147.584263E10E4@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 06:41 AM, Grant Likely wrote:
> On Tue, 14 May 2013 19:02:45 +0800, Chen Gang <gang.chen@asianux.com> wrote:
>> > 
>> > Since irq_data may be NULL, if so, we WARN_ON(), and continue, 'hwirq'
>> > which related with 'irq_data' has to initialize later, or it will cause
>> > issue.
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Applied, thanks.

Thank you too.

-- 
Chen Gang

Asianux Corporation
