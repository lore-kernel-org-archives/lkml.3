Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbbA2Otc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:49:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:1834 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbbA2Otb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:49:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,486,1418112000"; 
   d="scan'208";a="644506606"
Message-ID: <1422542869.21110.8.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] firmware: efi: remove unneeded guid unparse
From: Matt Fleming <matt.fleming@intel.com>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 29 Jan 2015 14:47:49 +0000
In-Reply-To: <1422542102-19348-1-git-send-email-ivan.khoronzhuk@linaro.org>
References: <1422542102-19348-1-git-send-email-ivan.khoronzhuk@linaro.org>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.33.239.181]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-29 at 16:35 +0200, Ivan Khoronzhuk wrote:
> There is no reason to translate guid number to string here.
> So remove it in order to not do unneeded work.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  drivers/firmware/efi/efi.c | 5 -----
>  1 file changed, 5 deletions(-)

Why the resend? I already picked this commit up,

  https://lkml.kernel.org/r/20150120223238.GC12079@codeblueprint.co.uk

