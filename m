Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019Ab3GWSIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:08:51 -0400
Received: from nbd.name ([46.4.11.11]:45986 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933709Ab3GWSIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:08:49 -0400
Message-ID: <51EEC52E.9020405@phrozen.org>
Date: Tue, 23 Jul 2013 20:02:22 +0200
From: John Crispin <john@phrozen.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 01/27] arch/mips/lantiq/xway: don't check resource with
 devm_ioremap_resource
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de> <1374602524-3398-2-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1374602524-3398-2-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/07/13 20:01, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang<wsa@the-dreams.de>

Acked-by: John Crispin <blogic@openwrt.org>
