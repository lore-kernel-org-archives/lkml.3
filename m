Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbaFPRqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:46:12 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:38743 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaFPRqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:46:10 -0400
Message-ID: <539F2D5F.9000708@cogentembedded.com>
Date: Mon, 16 Jun 2014 21:46:07 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tile: fix unused variable warning
References: <201406161716.s5GHGkKq026867@farm-0039.internal.tilera.com>
In-Reply-To: <201406161716.s5GHGkKq026867@farm-0039.internal.tilera.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/16/2014 09:14 PM, Chris Metcalf wrote:

> 'i' is unused in tile_net_dev_init() after commit d581ebf5a1f.

    Please also specify that commit's summary line in parens.

> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

WBR, Sergei

