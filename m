Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3BUXyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 18:54:24 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:62230 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab3BUXyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 18:54:23 -0500
MIME-Version: 1.0
In-Reply-To: <kg69ef$vdb$1@ger.gmane.org>
References: <kg69ef$vdb$1@ger.gmane.org>
Date: Fri, 22 Feb 2013 09:54:21 +1000
Message-ID: <CAPM=9ty0Apsk_5v+aguHQMzFhi9A9kMcWb8fXBmWus9Z=tA=JA@mail.gmail.com>
Subject: Re: Regression: Screen turns off when booting in EFI mode
From: Dave Airlie <airlied@gmail.com>
To: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> | radeon 0000:01:00.0: No connectors reported connected with modes
> | [drm] Cannot find any crtc or sizes - going 1024x768
>
> The connector is definitely connected, since this is a laptop with a
> built-in screen...
>

Can you get the log with drm.debug=6 from both boots as well?

Dave.
