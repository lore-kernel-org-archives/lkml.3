Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbbAGPzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:55:38 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:54150 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbbAGPze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:55:34 -0500
Message-ID: <54AD56EC.5020900@gmail.com>
Date: Wed, 07 Jan 2015 18:55:24 +0300
From: Dmitry Osipenko <digetx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, Paul Walmsley <paul@pwsan.com>
CC: linux-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Thierry Reding <treding@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] soc: tegra: pmc: restrict compilation of suspend-related
 support to ARM
References: <alpine.DEB.2.02.1412092224050.31750@utopia.booyaka.com> <20150107143354.GD1621@ulmo> <54AD4FB7.20600@gmail.com>
In-Reply-To: <54AD4FB7.20600@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07.01.2015 18:24, Dmitry Osipenko пишет:
> For now there is no feedback for my suspend bug patch (other than for V1), but,
> 

To be more correct, by V1 I meant http://patchwork.ozlabs.org/patch/423224/

-- 
Dmitry
