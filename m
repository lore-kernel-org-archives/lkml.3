Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbbAJWQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:16:33 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:57960 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbbAJWQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:16:31 -0500
Date: Sat, 10 Jan 2015 14:16:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Moritz Fischer <moritz.fischer@ettus.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] input: misc: Support NI Ettus Research USRP E3x0
 Button
Message-ID: <20150110221626.GA9345@dtor-ws>
References: <1420761571-22903-1-git-send-email-moritz.fischer@ettus.com>
 <1420761571-22903-2-git-send-email-moritz.fischer@ettus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420761571-22903-2-git-send-email-moritz.fischer@ettus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Moritz,

On Fri, Jan 09, 2015 at 12:59:29AM +0100, Moritz Fischer wrote:
> +static struct platform_driver e3x0_button_driver = {
> +	.driver		= {
> +		.name	= "e3x0-button",
> +		.of_match_table = of_match_ptr(e3x0_button_match),

You forgot to assign .pm pointer here. I fixed it up and applied the
driver.

Thanks.

-- 
Dmitry
