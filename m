Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaGJH3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:29:43 -0400
Received: from odin2.bull.net ([129.184.85.11]:39103 "EHLO odin2.bull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaGJH3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:29:42 -0400
Message-ID: <53BE40E3.6000101@bull.net>
Date: Thu, 10 Jul 2014 09:29:39 +0200
From: Sebastien Buisson <sebastien.buisson@bull.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow increasing the buffer-head per-CPU LRU size
References: <53B667F9.90306@bull.net>	<87y4w6sbp7.fsf@tassilo.jf.intel.com>	<53BA772C.6040506@bull.net>	<20140707163003.GA18735@two.firstfloor.org>	<20140707152936.a286b0f46ae1b06aa41c1959@linux-foundation.org>	<20140707224634.GE18735@two.firstfloor.org>	<53BB8F7C.1060505@bull.net>	<53BE37E5.4030407@bull.net> <20140710000745.37be4400.akpm@linux-foundation.org>
In-Reply-To: <20140710000745.37be4400.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
X-Originating-IP: [10.192.1.123]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 10/07/2014 09:07, Andrew Morton a écrit :
> This hardwires 16 if ext4&quota and 8 otherwise.  There's no way for
> anyone to alter this decision if they think it will be helpful (or
> harmful) in their setup.

In fact I do not know how to let experienced people alter the value 
without confusing the others with yet another obscure config option 
(Andi's comment). I would welcome any suggestion to achieve this.

Many thanks,
Sebastien.
