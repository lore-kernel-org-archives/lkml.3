Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaB1WKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:10:10 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:37429 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbaB1WKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:10:07 -0500
Message-ID: <5311093D.3090409@mm-sol.com>
Date: Sat, 01 Mar 2014 00:10:05 +0200
From: Georgi Djakov <gdjakov@mm-sol.com>
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: linux-mmc@vger.kernel.org, cjb@laptop.org, ulf.hansson@linaro.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v9 3/3] mmc: sdhci-msm: Add platform_execute_tunning implementation
References: <1393586675-14628-1-git-send-email-gdjakov@mm-sol.com> <1393586675-14628-4-git-send-email-gdjakov@mm-sol.com> <F9D8CFEF-1A3C-4B25-B593-419C56E3A168@codeaurora.org>
In-Reply-To: <F9D8CFEF-1A3C-4B25-B593-419C56E3A168@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.02.14, 18:51, Kumar Gala wrote:
> 
> On Feb 28, 2014, at 5:24 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
> 
>> This patch adds implementation for platform specific tuning in order to support
>> HS200 bus speed mode on Qualcomm SDHCI controller.
>>
>> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
>> Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
>> ---
>> drivers/mmc/host/sdhci-msm.c |  424 +++++++++++++++++++++++++++++++++++++++++-
>> 1 file changed, 418 insertions(+), 6 deletions(-)
> 
> minor nit, in subject (platform_execute_tuning, with one ’n’).
> 
> - k

Oh, of course! Thanks!

BR,
Georgi

