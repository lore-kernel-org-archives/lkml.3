Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbbARVsI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 16:48:08 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:44403 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbbARVsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 16:48:05 -0500
Date: Sun, 18 Jan 2015 13:47:57 -0800
From: Paul Burton <paul.burton@imgtec.com>
To: Markos Chandras <Markos.Chandras@imgtec.com>
CC: <linux-mips@linux-mips.org>, Matthew Fortune <matthew.fortune@imgtec.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH] MIPS,prctl: add PR_[GS]ET_FP_MODE prctl options for MIPS
Message-ID: <20150118214757.GU28594@NP-P-BURTON>
References: <1420719457-690-1-git-send-email-paul.burton@imgtec.com>
 <54B519B6.5040604@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <54B519B6.5040604@imgtec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.168.159.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 01:12:22PM +0000, Markos Chandras wrote:
> Hi,
> 
> I think the "MIPS,prctl" in the title should be "MIPS: prctl"

I used the comma to denote a list - that is, this change affects both
MIPS & the generic prctl code. To me your "MIPS: prctl" suggestion would
indicate that the changes are confined to arch/mips.

> I have also CC'd the LKML and the linux-api mailing lists since this
> touches the kernel ABI with the new PR_[GS]ET_FP_MODE definitions.

Thanks,
    Paul
