Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbaAURD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:03:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38545 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbaAURDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:03:25 -0500
Message-ID: <52DEA84D.2090306@zytor.com>
Date: Tue, 21 Jan 2014 09:03:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>, "H.J. Lu" <hjl.tools@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] Use __kernel_long_t in struct timex
References: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com> <1388165112-6545-2-git-send-email-hjl.tools@gmail.com> <20140121165803.GC20798@arm.com>
In-Reply-To: <20140121165803.GC20798@arm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 08:58 AM, Catalin Marinas wrote:
> 
> BTW, could we not avoid the #if and always use __kernel_long_t? This
> wouldn't break the user ABI.
> 

Ah yes, this is the wrong version of the patchset.  I already gave that
feedback and H.J. posted an update.  My bad.

	-hpa

