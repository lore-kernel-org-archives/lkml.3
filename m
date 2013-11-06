Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab3KFOxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:53:23 -0500
Received: from mail.active-venture.com ([67.228.131.205]:61194 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578Ab3KFOxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:53:20 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <527A57D9.3070402@roeck-us.net>
Date: Wed, 06 Nov 2013 06:53:13 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] OF: Introduce utility helper functions
References: <1383673816-29293-1-git-send-email-panto@antoniou-consulting.com> <1383673816-29293-6-git-send-email-panto@antoniou-consulting.com> <527A0A12.2050803@nsn.com> <57092A71-2C68-4B92-A748-5D0DE69EC141@antoniou-consulting.com>
In-Reply-To: <57092A71-2C68-4B92-A748-5D0DE69EC141@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pantelis,

On 11/06/2013 01:34 AM, Pantelis Antoniou wrote:

>
> As I mentioned earlier I'm trying to get this accepted in general term and then we'll
> get around fixing any minor problems.
>

I think it is quite likely at this point that your series will be accepted.

However, from my experience with larger submissions like this one, it is quite common
that the maintainers ask for all feedback to be addressed before that happens -
especially for feedback like this, where there is common understanding that some
changes to the code are necessary.

Maybe the device tree maintainers could chime in at this point and let us all know
what will need to happen to get the series accepted.

Thanks,
Guenter


