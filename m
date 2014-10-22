Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaJVDPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 23:15:21 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:60831 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaJVDPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 23:15:19 -0400
Message-ID: <54472144.3090802@martingkelly.com>
Date: Tue, 21 Oct 2014 20:15:16 -0700
From: Martin Kelly <martin@martingkelly.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, rientjes@google.com,
        david.vrabel@citrix.com, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH v2] x86, e820: panic on sanitizing invalid memory map
References: <1413859062-26594-1-git-send-email-martin@martingkelly.com> <alpine.DEB.2.11.1410211043150.5308@nanos> <54465FC2.1030106@martingkelly.com> <alpine.DEB.2.11.1410212141350.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410212141350.5308@nanos>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 12:44 PM, Thomas Gleixner wrote:
> On Tue, 21 Oct 2014, Martin Kelly wrote:
>> On 10/21/2014 01:56 AM, Thomas Gleixner wrote:
>> Thomas, do you see any issues with a revision that separates out the
>> return values (0 for a map with 1 entry, -1 for a map with invalid
>> entries) and adds checks in the callers, where appropriate?
> 
> I think that's a sane approach.
> 

Alright, I will work on a new patch doing that, separating out each call
site (and relevant error handling) into its own patch.
