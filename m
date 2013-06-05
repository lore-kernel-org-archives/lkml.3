Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3FEQ3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:29:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39628 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab3FEQ3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:29:40 -0400
Message-ID: <51AF6771.1070108@wwwdotorg.org>
Date: Wed, 05 Jun 2013 10:29:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Override bits for PLLM
References: <1370441329-8619-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1370441329-8619-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 08:08 AM, Peter De Schrijver wrote:
> PLLM has override bits on Tegra30 and Tegra114. This patchset implements
> support for them for both Tegra30 and Tegra114.

The series,

Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>

(assuming the one comment I already made is fixed)

