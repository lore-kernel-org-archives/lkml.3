Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbaGXPeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:34:23 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:23073 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759114AbaGXPeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:34:21 -0400
Message-ID: <53D1277A.2020006@itdev.co.uk>
Date: Thu, 24 Jul 2014 16:34:18 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
CC: Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: atmel_mxt_ts - split config update a bit
References: <20140723232954.GA13095@core.coreip.homeip.net>
In-Reply-To: <20140723232954.GA13095@core.coreip.homeip.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/07/14 00:29, Dmitry Torokhov wrote:
> Let's split config update code a bit so it is hopefully a bit easier to
> read. Also, the firmware update callback should be the entity releasing
> firmware blob, not lower layers.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks, this is obviously sensible. I will bring this into my patch series
and test it.
