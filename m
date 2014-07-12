Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaGLPFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 11:05:53 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53107 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaGLPFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 11:05:50 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53C14ECD.7050105@roeck-us.net>
Date: Sat, 12 Jul 2014 08:05:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: stub: Add support for SMBus block commands
References: <1404742983-27303-1-git-send-email-linux@roeck-us.net>	<20140708215453.0677d3ed@endymion.delvare>	<53BC4F15.9030608@roeck-us.net> <20140712112019.618d8a03@endymion.delvare>
In-Reply-To: <20140712112019.618d8a03@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On 07/12/2014 02:20 AM, Jean Delvare wrote:
> Hi Guenter,
>

Something else:

Any idea how we could inject errors ? Error path testing would be quite useful.

Thanks,
Guenter

