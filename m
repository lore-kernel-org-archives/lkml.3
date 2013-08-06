Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab3HFR1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:27:11 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:32780 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab3HFRXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:23:52 -0400
Message-ID: <52013124.3010701@gmail.com>
Date: Tue, 06 Aug 2013 10:23:48 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: linux-mips@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 25/31] mips/kvm: Add some asm-offsets constants used by
 MIPSVZ.
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com> <1370646215-6543-26-git-send-email-ddaney.cavm@gmail.com> <20130616113102.GG20046@linux-mips.org>
In-Reply-To: <20130616113102.GG20046@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2013 04:31 AM, Ralf Baechle wrote:
> Patch looks ok but why not combine this patch with the previous one?
>

Because even though they both touch asm-offsets.c, they are offsets for 
unrelated structures.  I could try distributing these changes across 
several other patches, but getting the patch dependencies/ordering 
correct can be tricky.

David Daney


>    Ralf
>

