Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbbALKS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:18:27 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:48399 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbbALKS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:18:26 -0500
Message-ID: <54B39F6C.2030709@collabora.co.uk>
Date: Mon, 12 Jan 2015 11:18:20 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, Olof Johansson <olof@lixom.net>
CC: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 0/7] platform/chrome: Add user-space dev inferface
 support
References: <1420205572-2640-1-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1420205572-2640-1-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/02/2015 02:32 PM, Javier Martinez Canillas wrote:
> 
> The mainline ChromeOS Embedded Controller (EC) driver is still missing some
> features that are present in the downstream ChromiumOS tree. These are:
> 
>   - Low Pin Count (LPC) interface
>   - User-space device interface
>   - Access to vboot context stored on a block device
>   - Access to vboot context stored on EC's nvram
>   - Power Delivery Device
>   - Support for multiple EC in a system
> 
> This is a second version of a series that adds support for the first two of
> the missing features: the EC LPC and EC character device interfaces that
> are used by user-space to access the ChromeOS EC. The support patches were
> taken from the downstream ChromiumOS 3.14 tree with the fixes and cleanups
> squashed to have a minimal patch-set.
> 

Any comments about this series? This is already a resend of a series posted
first on December, 9. I know it has been holiday season but I would really
appreciate some feedback since the patches have been in the list for a month.

Thanks a lot and best regards,
Javier
