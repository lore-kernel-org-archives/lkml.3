Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab3CHTqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:46:17 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:62004 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3CHTqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:46:15 -0500
MIME-Version: 1.0
In-Reply-To: <20130308194357.GA6622@phenom.dumpdata.com>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
	<1360351703-20571-16-git-send-email-yinghai@kernel.org>
	<20130308194357.GA6622@phenom.dumpdata.com>
Date: Fri, 8 Mar 2013 11:46:15 -0800
X-Google-Sender-Auth: UMTI1qYagS7pmeVYtI1UE0vRgcs
Message-ID: <CAE9FiQVGrYxxAE2mQfdqy_O=A8Rj5aqRAc2FHWaKn=LxhWnTYA@mail.gmail.com>
Subject: Re: [PATCH v2 15/26] xen, irq: call irq_realloc_desc_at() at first
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 11:43 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Fri, Feb 08, 2013 at 11:28:12AM -0800, Yinghai Lu wrote:
>> We will pre-reserve irq for all gsi at first for x86, so we have to
>> use realloc with it.
>
> Where are the GSI's pre-allocated?

In following patch.

I put this one forward, so it will not break git bisecting.
