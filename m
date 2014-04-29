Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbaD2IBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:01:16 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:59565 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792AbaD2IBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:01:15 -0400
Message-ID: <535F5BDE.2030309@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 13:29:26 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: Linux PPC dev <linuxppc-dev@ozlabs.org>, avagin@openvz.org,
        roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add new ptrace request macros on PowerPC
References: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com> <533BD922.4070009@linux.vnet.ibm.com>	<535F4E10.2020300@linux.vnet.ibm.com> <CAEjGV6yi5YY95tM-HY4akN4BGXGn4chA8_sCaqvWx3HPSu2V3w@mail.gmail.com>
In-Reply-To: <CAEjGV6yi5YY95tM-HY4akN4BGXGn4chA8_sCaqvWx3HPSu2V3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042908-6102-0000-0000-000005774E7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 12:36 PM, Michael Neuling wrote:
> How is it causing the problem?

As mentioned before, what I thought to be a problem is
something expected behaviour. So it's not a problem any
more. DSCR value inside the transaction will fall back
to default as kernel wont let user specified value to
remain applied for a long time.

