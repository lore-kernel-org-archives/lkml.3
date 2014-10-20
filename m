Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaJTOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:09:57 -0400
Received: from vader.hardeman.nu ([95.142.160.32]:34402 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaJTOJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:09:53 -0400
To: Tomas Melin <tomas.melin@iki.fi>
Subject: Re: [PATCH 1/2] [media] rc-core: fix =?UTF-8?Q?protocol=5Fchange?=  =?UTF-8?Q?=20regression=20in=20ir=5Fraw=5Fevent=5Fregister?=
X-PHP-Originating-Script: 0:rcmail.php
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 20 Oct 2014 16:09:50 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: m.chehab@samsung.com, james.hogan@imgtec.com, a.seppala@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomas Melin <tomas.j.melin@gmail.com>
In-Reply-To: <1413714113-7456-1-git-send-email-tomas.melin@iki.fi>
References: <1413714113-7456-1-git-send-email-tomas.melin@iki.fi>
Message-ID: <a751abe3b653291a69039c06dab5c496@hardeman.nu>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-19 12:21, Tomas Melin wrote:
> IR reciever using nuvoton-cir and lirc was not working anymore after
> upgrade from kernel 3.16 to 3.17-rcX.
> Bisected regression to commit da6e162d6a4607362f8478c715c797d84d449f8b
> ("[media] rc-core: simplify sysfs code").

FWIW, I think "not working" is slightly misleading. "Required additional 
configuration steps" is a better description, isn't it?

