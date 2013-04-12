Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3DLKQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 06:16:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab3DLKQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 06:16:19 -0400
Message-ID: <5167DEE9.6050006@redhat.com>
Date: Fri, 12 Apr 2013 18:16:09 +0800
From: Lingzhu Xiang <lxiang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 1/3] efi: Determine how much space is used by boot
 services-only variables
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com> <1365615967-27346-1-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1365615967-27346-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 01:46 AM, Matthew Garrett wrote:
>   	ops.query_variable_store = efi_query_variable_store;

Can't apply here. ops.query_variable_info = efi.query_variable_info?
