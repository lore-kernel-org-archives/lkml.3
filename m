Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbaJVPcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:32:23 -0400
Received: from smtp-out-086.synserver.de ([212.40.185.86]:1195 "EHLO
	smtp-out-085.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754246AbaJVPcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:32:20 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 21740
Message-ID: <5447CDFA.5030407@metafoo.de>
Date: Wed, 22 Oct 2014 17:32:10 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>, Peter Meerwald <pmeerw@pmeerw.net>
CC: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2] iio: inkern: Add of_xlate function to struct iio_info
References: <1413991783-24562-1-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1413991783-24562-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 05:29 PM, Ivan T. Ivanov wrote:
> When #iio-cells is greater than '0', the driver could provide
> a custom of_xlate function that reads the *args* and returns
> the appropriate index in registered IIO channels array.
>
> Add simple translation function, suitable for the most 1:1
> mapped channels in IIO chips, and use it when driver did not
> provide custom implementation.
>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.

