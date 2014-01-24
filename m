Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaAXOpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:45:16 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:38338 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaAXOpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:45:12 -0500
MIME-Version: 1.0
In-Reply-To: <20140124142112.GA30183@twins.programming.kicks-ass.net>
References: <CAOMZO5ASeLoa3s2PqaPqA-zd83hc8qQCHyfedP+KEzvitBpqog@mail.gmail.com>
	<20140124142112.GA30183@twins.programming.kicks-ass.net>
Date: Fri, 24 Jan 2014 12:45:11 -0200
Message-ID: <CAOMZO5C0dYC1tS+XCjJa9JhXRCSR_m-3CDcPZJFZwEavOd3mtg@mail.gmail.com>
Subject: Re: Warning at mm/slub.c
From: Fabio Estevam <festevam@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, dave.hansen@linux.intel.com
Cc: penberg@kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 12:21 PM, Peter Zijlstra <peterz@infradead.org> wrote:

> Dave Hansen already send a fix for that:
>
> lkml.kernel.org/r/52D5746F.2040604@intel.com

Thanks, Peter. Dave's patch fixes the warning.

Dave,

Do you plan to submit your fix as a formal patch?

Regards,

Fabio Estevam
