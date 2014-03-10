Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbaCJUrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:47:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbaCJUru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:47:50 -0400
Date: Mon, 10 Mar 2014 13:47:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        rtc-linux@googlegroups.com, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 4/6] rtc: pm8xxx: add support for devicetree
Message-Id: <20140310134748.dae1b77cfac3df68bd2c1d69@linux-foundation.org>
In-Reply-To: <1394477089-3996-5-git-send-email-joshc@codeaurora.org>
References: <1394477089-3996-1-git-send-email-joshc@codeaurora.org>
	<1394477089-3996-5-git-send-email-joshc@codeaurora.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 13:44:47 -0500 Josh Cartwright <joshc@codeaurora.org> wrote:

> Add support for describing the PM8921/PM8058 RTC in device tree.
> 
> Additionally:
>    - drop support for describing the RTC using platform data,
>      as there are no current in tree users who do so.
>    - make allow_set_time a device-specific flag, instead of mucking
>      with the rtc_ops

Is this tested with and without CONFIG_OF?
