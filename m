Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3HaUzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 16:55:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26678 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab3HaUzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 16:55:38 -0400
Date: Sat, 31 Aug 2013 23:55:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] staging: android/timed_output: Create 'enable' attribute
 automatically
Message-ID: <20130831205522.GV6329@mwanda>
References: <1377973978-25625-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377973978-25625-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 11:32:58AM -0700, Guenter Roeck wrote:
> The 'enable' attribute is needed for all timed_output_class devices.
> It can thus be created automatically when creating the timed_output device.
> This simplifies the code and ensures that the attribute exists when the
> udev event announcing device registration is generated.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

This patch has a bug so it was replaced by a v2 patch in a later thread.

regards,
dan carpenter
