Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab3J2Qav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:30:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42443 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758312Ab3J2Qas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:30:48 -0400
Message-ID: <526FE2B6.8050701@codeaurora.org>
Date: Tue, 29 Oct 2013 09:30:46 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>,
        Lars-Peter Clausen <lars@metafoo.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH v3 02/10] spmi: Linux driver framework for SPMI
References: <cover.1382985169.git.joshc@codeaurora.org> <149bbfe89e37376cc176c3aeb6c1fab9e4fd2b91.1382985169.git.joshc@codeaurora.org> <526FD278.8080102@metafoo.de> <20131029155616.GG20207@joshc.qualcomm.com>
In-Reply-To: <20131029155616.GG20207@joshc.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/13 08:56, Josh Cartwright wrote:
>
>>> +#define to_spmi_controller(d) container_of(d, struct spmi_controller, dev)
>> Should be a inline function for better type safety.
> Sounds good.  Will change the to_spmi_*() macros.

I was under the impression that container_of() already does type
checking. At least it will ensure that typeof(d) == typeof(dev) in the
above example which is about as good as it can get.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

