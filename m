Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaJBNaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:30:20 -0400
Received: from smtp-out-024.synserver.de ([212.40.185.24]:1144 "EHLO
	smtp-out-020.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752718AbaJBNaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:30:18 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 2511
Message-ID: <542D5377.90201@metafoo.de>
Date: Thu, 02 Oct 2014 15:30:31 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Jonathan Cameron <jic23@kernel.org>
CC: Sachin Kamat <sachin.kamat@linaro.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>, linux-iio@vger.kernel.org,
        svarbanov@mm-sol.com, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] iio: inkern: Add of_xlate function to struct iio_dev
References: <1412253128-32165-1-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1412253128-32165-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 02:32 PM, Ivan T. Ivanov wrote:
> When #iio-cells is greater than '0', the driver could provide
> a custom of_xlate function that reads the *args* and returns
> the appropriate index in registered IIO channels array.

Do you have an example of a device that doesn't want to use the default 
mapping? If yes please include it in the commit message, otherwise it is 
fairly hard to say whether this makes sense or not.

>
> Add simple translation function, suitable for the most 1:1
> mapped channels in IIO chips, and use it when driver did not
> provide custom implementation.
>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

