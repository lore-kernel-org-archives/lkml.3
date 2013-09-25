Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3IYJP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 05:15:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab3IYJPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 05:15:54 -0400
Message-ID: <5242A9C6.9040606@suse.cz>
Date: Wed, 25 Sep 2013 11:15:50 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] modpost: Fix secondary errors seen if a single module
 build fails
References: <1379219942-31545-1-git-send-email-linux@roeck-us.net> <52384C72.4040403@suse.cz> <20130918140549.GA15490@roeck-us.net>
In-Reply-To: <20130918140549.GA15490@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.9.2013 16:05, Guenter Roeck wrote:
> To follow up on this - are you at the Linux Plumbers conference ?
> If yes maybe we can meet briefly and discuss how to proceed.
> I'd volunteer to create a patch to add the above functionality if
> people think it is valuable, but I would like to keep it as
> separate patch.

Sorry, I was not at the LPC and had vacation at that time. I see Rusty
already merged your patch, that's great.

Michal

