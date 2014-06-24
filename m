Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaFXIjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:39:01 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11823 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaFXIi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:38:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Jun 2014 01:32:56 -0700
Message-ID: <53A93913.4070304@nvidia.com>
Date: Tue, 24 Jun 2014 14:08:43 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "spk.linux@gmail.com" <spk.linux@gmail.com>
Subject: Re: [PATCH 1/1] regulator: as3722: Fix incorrect parameter initialization
References: <1403598283-21099-1-git-send-email-sachin.kamat@samsung.com>
In-Reply-To: <1403598283-21099-1-git-send-email-sachin.kamat@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2014 01:54 PM, Sachin Kamat wrote:
> 'name' field was re-initialized and getting overwritten in some
> cases possibly due to a typo. Code inspection says the second time
> it should be 'sname' instead of 'name'. Replace it.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
>


Agree, thanks for finding this.

Reviewed-by: Laxman Dewangan <ldewangan@nvidia.com>
