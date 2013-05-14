Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab3ENHQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:16:55 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44761 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3ENHQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:16:53 -0400
Message-ID: <5191E4E0.7020505@intel.com>
Date: Tue, 14 May 2013 08:16:48 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: Lingzhu Xiang <lxiang@redhat.com>, Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] efivarfs: Never return ENOENT from firmware again
References: <5b6476bf31dc699a0e6f3983e78447eeac34d831.1368180585.git.lxiang@redhat.com>  <51913D4B.2000606@intel.com> <1368506197.21417.172.camel@linux-s257.site>
In-Reply-To: <1368506197.21417.172.camel@linux-s257.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 05:36 AM, joeyli wrote:
> I found the "[PATCH] x86, efi: initial the local variable of DataSize to
> zero" lost in urgent branch, and it also didn't in Linus's v3.10-rc1.
> 
> Did this patch move to other branch?

It appears I dropped this patch when doing the rebase against -rc1. I'm
really sorry about that. I've applied it again.

Thanks for being so diligent.
