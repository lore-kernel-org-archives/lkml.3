Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3CAAx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:53:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43187 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab3CAAxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:53:55 -0500
Message-ID: <512FFBC4.4070400@zytor.com>
Date: Thu, 28 Feb 2013 16:52:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
        tglx@linutronix.de, konrad.wilk@oracle.com, rostedt@goodmis.org,
        gregkh@linuxfoundation.org, samu.kallio@aberdeencloud.com,
        kraman@redhat.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] mm/x86: Patch out arch_flush_lazy_mmu_mode() when running
 on bare metal
References: <1362092149-32381-1-git-send-email-boris.ostrovsky@oracle.com> <20130228233720.GB17468@pd.tnic> <20130301000539.GA31649@hansolo.jdub.homelinux.org> <512FF331.5050008@zytor.com> <20130301003629.GG9767@pd.tnic> <20130301004211.GB31649@hansolo.jdub.homelinux.org>
In-Reply-To: <20130301004211.GB31649@hansolo.jdub.homelinux.org>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 04:42 PM, Josh Boyer wrote:
> On Fri, Mar 01, 2013 at 01:36:29AM +0100, Borislav Petkov wrote:
>> On Thu, Feb 28, 2013 at 04:15:45PM -0800, H. Peter Anvin wrote:
>>>> I'll try to get someone to test this tomorrow.
>>
>> Btw, you'd need to apply that other patch too
>>
>> http://marc.info/?l=xen-devel&m=136206183814547&w=2
>>
>> so that arch_flush_lazy_mmu_mode() has at least one caller on x86_64.
> 
> Yeah, we already have that applied.  It stops crashes in xen
> environments so we pulled it in as a bugfix.  Thanks though!
> 

Who are "we"?

	-hpa


