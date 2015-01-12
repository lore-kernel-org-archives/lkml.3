Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbbALOj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:39:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbbALOj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:39:27 -0500
Date: Mon, 12 Jan 2015 15:38:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pratyush Anand <panand@redhat.com>
Cc: tixy@linaro.org, linux@arm.linux.org.uk, ananth@in.ibm.com,
        sandeepa.prabhu@linaro.org, catalin.marinas@arm.com,
        will.deacon@arm.com, linux-kernel@vger.kernel.org,
        anil.s.keshavamurthy@intel.com, masami.hiramatsu.pt@hitachi.com,
        wcohen@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 8/8] ARM64: Add uprobe support
Message-ID: <20150112143800.GC25914@redhat.com>
References: <cover.1420038188.git.panand@redhat.com> <0694af6935f9c6873ef8d25ad51630a40a74a116.1420038188.git.panand@redhat.com> <20150109175936.GB13161@redhat.com> <54B355FA.60702@redhat.com> <54B36D8E.4030001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B36D8E.4030001@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12, Pratyush Anand wrote:
>
> Hi Oleg,
>
> How can I generate a scenario to test:
>
> a) arch_uprobe_xol_was_trapped
> b) arch_uprobe_abort_xol

For example, you can probe something like

	*(int *)NULL = 0;

See also the x86 test-case in https://lkml.org/lkml/2011/10/21/148
and the whole thread.

Oleg.

