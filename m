Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab3F0PSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:18:01 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:37177 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753806Ab3F0PR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:17:58 -0400
Message-ID: <51CC57A3.6020601@itdev.co.uk>
Date: Thu, 27 Jun 2013 16:17:55 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: Atmel updates to atmel_mxt_ts touch controller driver - v6
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dimitry-

Nick Dyer wrote:
> Some minor updates to these patches to address review comments. I've rebased
> them on the latest dtor/next tree.

Apologies, I forgot to add Yufeng's Acked-by lines. To save cluttering up
the list, I've pushed a new version with just that change to

git@github.com:ndyer/linux.git

the tag is

for-next-20130627-v7
