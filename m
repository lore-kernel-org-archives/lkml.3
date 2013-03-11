Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab3CKSG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:06:56 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:64109 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3CKSGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:06:54 -0400
Message-ID: <513E2B89.40308@cogentembedded.com>
Date: Mon, 11 Mar 2013 22:07:53 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org, juhosg@openwrt.org,
        blogic@openwrt.org, kaloz@openwrt.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: use newly introduced devm_ioremap_resource()
References: <1363015477-29685-1-git-send-email-silviupopescu1990@gmail.com>
In-Reply-To: <1363015477-29685-1-git-send-email-silviupopescu1990@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/11/2013 06:24 PM, Silviu-Mihai Popescu wrote:

> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
>
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
>
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---
>   arch/mips/pci/pci-ar71xx.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
    I think the idea was to combine changes to the 2 files in one patch.
Then the subject will truly reflect what it's doing...

WBR, Sergei

