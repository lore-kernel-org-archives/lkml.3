Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966034Ab3FUBY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 21:24:58 -0400
Received: from intranet.asianux.com ([58.214.24.6]:55817 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965983Ab3FUBYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 21:24:55 -0400
X-Spam-Score: -100.8
Message-ID: <51C3AB33.6000901@asianux.com>
Date: Fri, 21 Jun 2013 09:24:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "'Jiri Kosina'" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/itimer.c: beautify code, not need check 'value',
 so save one instruction, simpler and easier for readers.
References: <51C2E6F9.80107@asianux.com> <51C2EF71.4010308@asianux.com> <alpine.DEB.2.02.1306201455330.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306201455330.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 08:55 PM, Thomas Gleixner wrote:
> On Thu, 20 Jun 2013, Chen Gang wrote:
> 
>> > 
>> > Oh, sorry, maybe it is a trivial patch, also need send to
>> > trivial@kernel.org.
> No. This is not a trivial patch, it's changing the code flow.
>  

OK, that is not a trivial patch, but a minor patch, is it correct ??

;-)


Thanks.
-- 
Chen Gang

Asianux Corporation
