Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3CaLae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 07:30:34 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:15290 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3CaLad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 07:30:33 -0400
Date: Sun, 31 Mar 2013 13:30:24 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6]  Make return type of i2c_del_adapter() (and
 i2c_del_mux_adapter()) void
Message-ID: <20130331133024.786d6c33@endymion.delvare>
In-Reply-To: <1362853009-20789-1-git-send-email-lars@metafoo.de>
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  9 Mar 2013 19:16:43 +0100, Lars-Peter Clausen wrote:
> Lars-Peter Clausen (6):
>   i2c: Remove detach_adapter
>   i2c: i2c_del_adapter: Don't treat removing a non-registered adapter
>     as error
>   i2c: Ignore return value of i2c_del_adapter()
>   i2c: Make return type of i2c_del_adapter() void
>   i2c: Ignore the return value of i2c_del_mux_adapter()
>   i2c: Make the return type of i2c_del_mux_adapter() void

FWIW I tested the whole series successfully on my Asus Z8NA-D6 board.

-- 
Jean Delvare
