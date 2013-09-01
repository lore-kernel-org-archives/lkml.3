Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab3IAA5e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 20:57:34 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56365 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3IAA5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 20:57:33 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sat, 31 Aug 2013 19:57:31 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <522290FA.2080502@roeck-us.net>
Date: Sat, 31 Aug 2013 17:57:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] staging: android/timed_output: Create 'enable' attribute
 automatically
References: <1377980453-29038-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1377980453-29038-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2013 01:20 PM, Guenter Roeck wrote:
> The 'enable' attribute is needed for all timed_output_class devices.
> It can thus be created automatically when creating the timed_output device.
> This simplifies the code and ensures that the attribute exists when the
> udev event announcing device registration is generated.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Just noticed that Greg already queued a patch to fix this problem.
Sorry for the noise.

Guenter


