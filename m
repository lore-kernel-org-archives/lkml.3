Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab3HTSEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:04:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab3HTSEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:04:34 -0400
Message-ID: <1377021844.3591.1.camel@t520.redhat.com>
Subject: Re: [PATCH] arm64: add screen_info for console support
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Date: Tue, 20 Aug 2013 14:04:04 -0400
In-Reply-To: <20130820171453.GF21383@arm.com>
References: <1376842970.11104.11.camel@t520.redhat.com>
	 <20130820133733.GF26129@mudshark.cambridge.arm.com>
	 <20130820171453.GF21383@arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 18:14 +0100, Catalin Marinas wrote:
> I was wondering about this but do we need screen_info for DUMMY_CONSOLE
> as well?

I thought so because my grep turned up a reference to screen_info in
dummycon.c but a closer look shows that only applies to arm.

--Mark


