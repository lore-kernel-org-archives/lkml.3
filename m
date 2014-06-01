Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbaFAJP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 05:15:29 -0400
Received: from smtp-out-124.synserver.de ([212.40.185.124]:1316 "EHLO
	smtp-out-124.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbaFAJP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 05:15:27 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 19602
Message-ID: <538AEF16.5070904@metafoo.de>
Date: Sun, 01 Jun 2014 11:15:02 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Jonathan Cameron <jic23@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: adc: ad_sigma_delta.c:  Cleaning up uninitialized
 variables
References: <1401577904-4764-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1401577904-4764-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2014 01:11 AM, Rickard Strandqvist wrote:
> There is a risk that the variable will be used without being initialized.
>
> This was largely found by using a static code analysis program called cppcheck.

This looks like a false positive. And if it was not a false positive the 
correct fix certainly is not to initialize the variable to some random value 
to silence the warning.

- Lars

