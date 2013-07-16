Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab3GPGbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:31:40 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:61449 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab3GPGbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:31:38 -0400
MIME-Version: 1.0
In-Reply-To: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
Date: Tue, 16 Jul 2013 12:01:37 +0530
Message-ID: <CAKohponiPd6YZFiQGY3UXdtb0WDWsqsPoZJ-53z6Qjm4e7ap_w@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] ARM: DT: update cpu device of_node
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Sudeep.KarkadaNagesha@arm.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, cpufreq@vger.kernel.org,
        arnd@arndb.de, olof@lixom.net, lorenzo.pieralisi@arm.com,
        rob.herring@calxeda.com, grant.likely@linaro.org, rjw@sisk.pl,
        gregkh@linuxfoundation.org, gregory.clement@free-electrons.com,
        kernel@pengutronix.de, shawn.guo@linaro.org, linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 July 2013 15:52,  <Sudeep.KarkadaNagesha@arm.com> wrote:
> Sudeep KarkadaNagesha (11):
>   cpufreq: imx6q-cpufreq: remove device tree parsing for cpu nodes
>   cpufreq: cpufreq-cpu0: remove device tree parsing for cpu nodes
>   cpufreq: highbank-cpufreq: remove device tree parsing for cpu nodes
>   cpufreq: spear-cpufreq: remove device tree parsing for cpu nodes
>   cpufreq: kirkwood-cpufreq: remove device tree parsing for cpu nodes
>   cpufreq: arm_big_little: remove device tree parsing for cpu nodes

For cpufreq part:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
