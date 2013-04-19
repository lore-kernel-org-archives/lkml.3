Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab3DSGUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:20:52 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18627 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3DSGUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:20:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 18 Apr 2013 23:20:50 -0700
Message-ID: <5170E14D.7030300@nvidia.com>
Date: Fri, 19 Apr 2013 11:46:45 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT v2] regulator: palmas: Don't update tstep register
 for SMPS3 and SMPS7
References: <1366352328.7079.0.camel@phoenix>
In-Reply-To: <1366352328.7079.0.camel@phoenix>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 April 2013 11:48 AM, Axel Lin wrote:
> SMPS3 and SMPS7 do not have tstep_addr setting, so current code actually
> writes 0 to smps12_ctl (offset is 0) register when set_ramp_delay callback
> is called for SMPS3 and SMPS7.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

