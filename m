Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3CABLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:11:30 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33728 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3CABL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:11:29 -0500
Message-ID: <5130003E.6000508@wwwdotorg.org>
Date: Thu, 28 Feb 2013 18:11:26 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: core: use devres_release() instead of devres_destroy()
References: <009401ce13c9$c01f6400$405e2c00$%han@samsung.com> <CACRpkdZBbuxogFy7NXiPnf4FR_eO2KJVck4C80dZZXuAZTsQzQ@mail.gmail.com>
In-Reply-To: <CACRpkdZBbuxogFy7NXiPnf4FR_eO2KJVck4C80dZZXuAZTsQzQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 05:54 PM, Linus Walleij wrote:
> On Tue, Feb 26, 2013 at 3:34 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> 
>> devres_release() can simplify the code, because devres_release()
>> will call the destructor for the resource as well as freeing
>> the devres data.
>>
>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Hm, Stephen, you OK with this?

Sounds reasonable,
Acked-by: Stephen Warren <swarren@nvidia.com>

