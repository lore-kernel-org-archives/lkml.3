Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3LSLtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:49:47 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51846 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab3LSLtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:49:45 -0500
Message-ID: <52B2DD56.8040401@imgtec.com>
Date: Thu, 19 Dec 2013 11:49:42 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: <linux-metag@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: metag: kernel: export 'cpu_core_map' in "topology.c"
References: <52B2A85C.9060303@gmail.com>
In-Reply-To: <52B2A85C.9060303@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_12_19_11_49_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/13 08:03, Chen Gang wrote:
> Need export 'cpu_core_map', or cann't pass compiling with allmodconfig,
> the related error:
> 
>     MODPOST 2909 modules
>   ERROR: "cpu_core_map" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Thanks, applied.

Cheers
James

