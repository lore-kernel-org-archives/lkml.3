Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719Ab3CUP5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:57:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:51239 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab3CUP5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:57:36 -0400
Message-ID: <514B1FEF.2090109@infradead.org>
Date: Thu, 21 Mar 2013 07:57:51 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for Mar 21 (input)
References: <20130321173832.c72cc034bd67452c9c2c567b@canb.auug.org.au>
In-Reply-To: <20130321173832.c72cc034bd67452c9c2c567b@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/13 23:38, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130320:
> 


on i386:

ERROR: "matrix_keypad_parse_of_params" [drivers/input/keyboard/tca8418_keypad.ko] undefined!



"matrix_keypad_parse_of_params" needs to be exported in
drivers/input/matrix-keymap.c.


-- 
~Randy
