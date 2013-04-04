Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764187Ab3DDRxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:53:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36795 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764142Ab3DDRxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:53:43 -0400
Message-ID: <515DBE24.3090501@wwwdotorg.org>
Date: Thu, 04 Apr 2013 11:53:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: mturquette@linaro.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Simon Glass <sjg@chromium.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9b 10/14] ARM: tegra: Define Tegra114 CAR binding
References: <1365097717-11874-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1365097717-11874-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 11:48 AM, Peter De Schrijver wrote:
> The device tree binding models Tegra114 CAR (Clock And Reset) as a single
> monolithic clock provider.
> 
> --
> 
> Mike,
> 
> This is a small binding doc update only. Hence I didn't make an entire new
> patch series, but just an updated version of this patch. Please apply this
> instead of '[PATCH v9 10/14] ARM: tegra: Define Tegra114 CAR binding'
> (http://www.spinics.net/lists/linux-tegra/msg10910.html).
> The rest of the series is not affected. 

I believe I was planning to take this series through the Tegra tree, so
I'm more looking for Mikes ack than for him to apply this.

If that's changed, there are some other Tegra clock bug-fixes that'd
benefit from moving to the clock tree.
