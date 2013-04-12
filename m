Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3DLKWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 06:22:54 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:43244 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3DLKWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 06:22:52 -0400
Message-ID: <5167E079.5060900@intel.com>
Date: Fri, 12 Apr 2013 11:22:49 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lingzhu Xiang <lxiang@redhat.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 1/3] efi: Determine how much space is used by boot
 services-only variables
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com> <1365615967-27346-1-git-send-email-matthew.garrett@nebula.com> <5167DEE9.6050006@redhat.com>
In-Reply-To: <5167DEE9.6050006@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/13 11:16, Lingzhu Xiang wrote:
> On 04/11/2013 01:46 AM, Matthew Garrett wrote:
>>       ops.query_variable_store = efi_query_variable_store;
> 
> Can't apply here. ops.query_variable_info = efi.query_variable_info?

It's against the 'urgent' branch at,

    git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
