Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab3LSMGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:06:03 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41015 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3LSMGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:06:00 -0500
Message-ID: <52B2E126.1030309@gmail.com>
Date: Thu, 19 Dec 2013 20:05:58 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-metag@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: metag: kernel: export 'cpu_core_map' in "topology.c"
References: <52B2A85C.9060303@gmail.com> <52B2DD56.8040401@imgtec.com>
In-Reply-To: <52B2DD56.8040401@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 07:49 PM, James Hogan wrote:
> On 19/12/13 08:03, Chen Gang wrote:
>> Need export 'cpu_core_map', or cann't pass compiling with allmodconfig,
>> the related error:
>>
>>     MODPOST 2909 modules
>>   ERROR: "cpu_core_map" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> 
> Thanks, applied.
> 

Thank you too.  :-)

-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
