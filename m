Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaEOO4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:56:37 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56186 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135AbaEOO4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:56:33 -0400
Message-ID: <5374D59E.2010502@linaro.org>
Date: Thu, 15 May 2014 15:56:30 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: QCOM: Enable ARM_AMBA option for Qcom SOCS.
References: <1400148535-30772-1-git-send-email-srinivas.kandagatla@linaro.org> <4FB5A6A0-B4C5-4E97-AD7D-8049CFA60393@codeaurora.org>
In-Reply-To: <4FB5A6A0-B4C5-4E97-AD7D-8049CFA60393@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Kumar,
On 15/05/14 15:31, Kumar Gala wrote:
> I’d rather have the driver have the select of ARM_AMBA and not the core support.  We clearly don’t need to build ARM_AMBA in to function.

Shouldn’t driver depend on it rather than selecting it?

Suggested approach will end up changing the way its done on other SOCs,
Currently all the SOCs select ARM_AMBA at there machine level Kconfig 
rather than each individual driver selecting it.

Am open to do it either way but doing it the way it exists is the 
something more acceptable I thought.


thanks,
srini
