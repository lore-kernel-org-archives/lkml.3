Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3DPKPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:15:19 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:35596 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915Ab3DPKPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:15:17 -0400
Message-ID: <516D24AB.8040604@console-pimps.org>
Date: Tue, 16 Apr 2013 11:15:07 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Fix UEFI variable paranoia
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com> <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/13 21:09, Matthew Garrett wrote:
> Identical to V5, except with the UCS2 helper functions included this time.

Thanks these looks good to me. I've applied all three patches to the
'urgent' branch.

-- 
Matt Fleming, Intel Open Source Technology Center
