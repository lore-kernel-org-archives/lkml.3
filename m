Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbaKES1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:27:39 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53647 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaKES1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:27:38 -0500
MIME-Version: 1.0
In-Reply-To: <1415162873-1874-2-git-send-email-slaoub@gmail.com>
References: <1415162873-1874-1-git-send-email-slaoub@gmail.com>
	<1415162873-1874-2-git-send-email-slaoub@gmail.com>
Date: Wed, 5 Nov 2014 10:27:36 -0800
Message-ID: <CA+8MBb+72pZfDke3ZVfY+Vtjqd63wx4qnccKP6H8UiSQrORJSA@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] x86, mce, severity: extend the the mce_severity
From: Tony Luck <tony.luck@gmail.com>
To: Chen Yucong <slaoub@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Andi Kleen <ak@linux.intel.com>,
        aravind.gopalakrishnan@amd.com,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define  ONEXCP        .excp = NO_EXCP

Shouldn't this be named "NOEXCP" and used in the initializations
for the deferred and UCNA table entries?

-Tony
