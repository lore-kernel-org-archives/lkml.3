Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab3FGGIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:08:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17692 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3FGGIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:08:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 06 Jun 2013 23:08:42 -0700
Message-ID: <51B178E7.1060802@nvidia.com>
Date: Fri, 7 Jun 2013 15:08:39 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] simplefb: add support for a8b8g8r8 pixel format
References: <1370503259-16618-1-git-send-email-acourbot@nvidia.com> <3356BC4D-EEF6-4FCA-9310-5B0727EBF288@jcrosoft.com> <51B0446A.4090305@nvidia.com> <51B0B4A2.4010104@wwwdotorg.org> <20130606162011.GV19468@game.jcrosoft.org> <CAOesGMgybYe_BBb0M4YS8tmM2C5jawf91OOyOuwwS5HSiUjPpQ@mail.gmail.com> <20130606163240.GY19468@game.jcrosoft.org>
In-Reply-To: <20130606163240.GY19468@game.jcrosoft.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 01:32 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> We're talking about adding a bunch of code instead of one line in a
>> table. Sorry, I NACK your NACK. If we get more entries we'll add the
>> parser, but not just for this.
> as there is no NACK so far I do take as a NACK

... which means?

Anyway, I have sent a new version of this patch that includes a summary 
motivating why we need it. Please explain clearly whether you accept it 
or not, and if not, what we need to do to add this mode in a 
satisfactory way.

Thanks,
Alex.

