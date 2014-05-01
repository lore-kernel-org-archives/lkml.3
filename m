Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaEARSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 13:18:51 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45205 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaEARSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 13:18:49 -0400
Message-ID: <536281F4.1000402@gmail.com>
Date: Thu, 01 May 2014 19:18:44 +0200
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/3] of: mtd: add NAND randomizer mode retrieval
References: <1398906592-24677-1-git-send-email-b.brezillon.dev@gmail.com>	<1398906592-24677-3-git-send-email-b.brezillon.dev@gmail.com> <20140501131605.9CB7CC409DA@trevor.secretlab.ca>
In-Reply-To: <20140501131605.9CB7CC409DA@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/05/2014 15:16, Grant Likely wrote:
> On Thu,  1 May 2014 03:09:51 +0200, Boris BREZILLON <b.brezillon.dev@gmail.com> wrote:
>> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>> ---
> No commit message? Immediate NAK. Please, make sure you write a
> description for each and every patch. This is not optional. Future
> readers want to know what this patch solves and any other information
> you can provide without having to read the diff.

My bad. I just sent a commit I forgot to rework to add a proper commit
message.
I'll add a commit message describing the different options for the
"nand-rnd-mode" property and update the nand DT bindings documentation.

Best Regards,

Boris
