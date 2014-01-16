Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaAPT3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 14:29:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaAPT3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:29:11 -0500
Date: Thu, 16 Jan 2014 14:28:42 -0500
From: Kyle McMartin <kyle@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] aarch64: always map VDSO at worst case alignment
Message-ID: <20140116192841.GN18705@redacted.bos.redhat.com>
References: <20140115214144.GF18705@redacted.bos.redhat.com>
 <20140116174344.GJ30257@mudshark.cambridge.arm.com>
 <20140116175318.GK18705@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116175318.GK18705@redacted.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 12:53:18PM -0500, Kyle McMartin wrote:
> I'll reboot a machine with this fix to test it as soon as possible.
> 
> Acked-by: Kyle McMartin <kyle@redhat.com>
> 

Yeah, looks to work properly, although I didn't test 64K pages in the
simulator.

--Kyle
