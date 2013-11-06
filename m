Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3KFPlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:41:46 -0500
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:14576 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3KFPlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:41:45 -0500
Message-ID: <527A6320.6040600@nsn.com>
Date: Wed, 06 Nov 2013 16:41:20 +0100
From: Alexander Sverdlin <alexander.sverdlin@nsn.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: ext Pantelis Antoniou <panto@antoniou-consulting.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] OF: Fixes in preperation of DT overlays
References: <1383673816-29293-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1383673816-29293-1-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1127
X-purgate-ID: 151667::1383752481-00004A43-9892A58C/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 05/11/13 18:50, ext Pantelis Antoniou wrote:
> This patchset introduces a number of fixes that are required
> for the subsequent patches that add DT overlays support.
> 
> Most of them are trivial, adding small bits that are missing,
> or exporting functions that were private before.
> 
> Pantelis Antoniou (5):
>   OF: Clear detach flag on attach
>   OF: Introduce device tree node flag helpers.
>   OF: export of_property_notify
>   OF: Export all DT proc update functions
>   OF: Introduce utility helper functions

All patches there we use as they are since July on our MIPS64 platforms. So, for all 5 patches:
Tested-by: Alexander Sverdlin <alexander.sverdlin@nsn.com>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@nsn.com>

>  drivers/of/Makefile |   2 +-
>  drivers/of/base.c   |  77 ++++++++--------
>  drivers/of/util.c   | 253 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of.h  | 119 ++++++++++++++++++++++++
>  4 files changed, 413 insertions(+), 38 deletions(-)
>  create mode 100644 drivers/of/util.c
> 

-- 
Best regards,
Alexander Sverdlin.
