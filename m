Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026Ab3DDLy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 07:54:28 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:60893 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab3DDLy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 07:54:26 -0400
Message-ID: <515D69B6.6040302@cogentembedded.com>
Date: Thu, 04 Apr 2013 15:53:26 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Alchemy: Fix typo "CONFIG_DEBUG_PCI"
References: <1365074738.1830.38.camel@x61.thuisdomein>
In-Reply-To: <1365074738.1830.38.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04-04-2013 15:25, Paul Bolle wrote:

> Also add a newline to a debugging printk that this fix enables.

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Entirely untested. Adding the newline adds a checkpatch warning for
> over 80 characters lines.

> 1) Typo was added in v3.2, through commit
> 7517de348663b08a808aff44b5300e817157a568 ("MIPS: Alchemy: Redo PCI as
> platform driver").

     This is the information for the changelog.

WBR, Sergei

