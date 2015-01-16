Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbbAPDSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:18:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbbAPDSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:18:50 -0500
Message-ID: <54B88302.2070903@redhat.com>
Date: Thu, 15 Jan 2015 22:18:26 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: SPCR table parsing
References: <54B880B5.6010907@redhat.com>
In-Reply-To: <54B880B5.6010907@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 10:08 PM, Jon Masters wrote:

> We're implementing support for SPCR table parsing shortly[0], since it
> will allow to deprecate supplying a "console=" (and eventually, also
> "earlycon=") on 64-bit ARM servers, where it's not always the case that
> we can assume a 16550 at a specific address. SPCR has been provided on
> x86 systems since 2000 but is not (yet) supported by Linux.
> 
> If anyone knows of existing efforts on e.g. x86 or IA64, please get in
> touch. I expect the initial implementation to require revision 2+ modern
> server systems and possibly be limited to ARM initially.

Side note: I preemptively had this added to the SBBR so it's already
required on ARM servers, and have confirmed the reference systems out
there have valid tables for us to use ahead of time.

Jon.

