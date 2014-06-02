Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaFBUtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:49:51 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:52191 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbaFBUtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:49:49 -0400
Message-ID: <538CE36B.8030708@mm-sol.com>
Date: Mon, 02 Jun 2014 23:49:47 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>, linux@arm.linux.org.uk,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, sboyd@codeaurora.org,
        rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 3/4] ARM: dts: qcom: Add APQ8084 Global Clock Controller
 DT node
References: <1401551134-28485-1-git-send-email-gdjakov@mm-sol.com> <1401551134-28485-4-git-send-email-gdjakov@mm-sol.com> <DDE79254-2F56-47AC-A689-5A0E8E131126@codeaurora.org>
In-Reply-To: <DDE79254-2F56-47AC-A689-5A0E8E131126@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.06.14, 23:41, Kumar Gala wrote:
> 
> On May 31, 2014, at 10:45 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
> 
>> This patch adds the necessary node to probe the global clock
>> controller on APQ8084 platforms.
>>
>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
>> ---
>> arch/arm/boot/dts/qcom-apq8084.dtsi |   10 ++++++++++
>> 1 file changed, 10 insertions(+)
> 
> Can you split the 2 DT patches into their own patchset since they will go via the qcom/arm-soc tree and not Mike’s clk tree.
> 
> thanks
> 

Sure! Thanks!

