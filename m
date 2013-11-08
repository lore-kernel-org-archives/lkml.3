Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab3KHSWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:22:39 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:43411 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab3KHSWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:22:37 -0500
MIME-Version: 1.0
In-Reply-To: <1383863145-8826-1-git-send-email-olof@lixom.net>
References: <1383863145-8826-1-git-send-email-olof@lixom.net>
Date: Fri, 8 Nov 2013 10:22:36 -0800
X-Google-Sender-Auth: TSbWRBxd3SmS6QRx9Np2t_SM3bM
Message-ID: <CANLzEktOccLaQGwO2V43eTMT=dZhytuNvo6FzD6W41Zf9E-YGg@mail.gmail.com>
Subject: Re: [PATCH] platform: add chrome platform directory
From: Benson Leung <bleung@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 2:25 PM, Olof Johansson <olof@lixom.net> wrote:
> It makes sense to split out the Chromebook/Chromebox hardware platform
> drivers to a separate subdirectory, since some of it will be shared
> between ARM and x86.
>
> This moves over the existing chromeos_laptop driver without making
> any other changes, and adds appropriate Kconfig entries for the new
> directory. It also adds a MAINTAINERS entry for the new subdir.
>
> Signed-off-by: Olof Johansson <olof@lixom.net>

Reviewed-by: Benson Leung <bleung@chromium.org>


-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
