Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3BUTYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:24:09 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39172 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3BUTYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:24:07 -0500
Message-ID: <51267454.5040607@wwwdotorg.org>
Date: Thu, 21 Feb 2013 12:24:04 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Shawn Joo <sjoo@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: use regulator name for sysfs
References: <1361433237-3217-1-git-send-email-sjoo@nvidia.com>
In-Reply-To: <1361433237-3217-1-git-send-email-sjoo@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 12:53 AM, Shawn Joo wrote:
> regulator is named by numbering on sysfs, e.g. regulator.0, regulator.1
> it confuses to find desired regulator before counting the order.
> add option for regulator name by use_name_onsysfs.
> if it is true and name is not NULL, desc's name will be the name.
> e.g. if name in desc is "LDO0", then regulator.LDO0 on sysfs.
> otherwise it follows origin.

Does it make sense to make this change always, rather than based on some
new flag in regulator_desc?

Another place a similar change might be useful is debugfs.
