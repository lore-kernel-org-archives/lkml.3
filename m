Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaCIEu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 23:50:28 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:46368 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaCIEu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 23:50:27 -0500
MIME-Version: 1.0
In-Reply-To: <20140306180422.4e27ae82f646e0e669f69cbb@skynet.be>
References: <20140306180422.4e27ae82f646e0e669f69cbb@skynet.be>
Date: Sat, 8 Mar 2014 20:50:26 -0800
Message-ID: <CAN8TOE9NavAny9AH09X3-Rvwq_frU6-ZSe1mC5g-KBfBZ7v76g@mail.gmail.com>
Subject: Re: [PATCH v2 linux-next] mtd: block2mtd: check device size
From: Brian Norris <computersforpeace@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "ezequiel.garcia" <ezequiel.garcia@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 2:04 AM, Fabian Frederick <fabf@skynet.be> wrote:
> fixme applied : check device size is a multiple of erasesize.
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Pushed to l2-mtd.git. Thanks!

Brian
