Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab3BNE0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 23:26:39 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:61178 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab3BNE0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 23:26:38 -0500
Date: Wed, 13 Feb 2013 20:26:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benson Leung <bleung@chromium.org>
Cc: rydberg@euromail.se, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, khali@linux-fr.org, olofj@chromium.org,
        djkurtz@chromium.org, dudl@cypress.com
Subject: Re: [PATCH v2 1/1] Input: mouse: cyapa - Add support for cyapa smbus
 protocol
Message-ID: <20130214042635.GC2472@core.coreip.homeip.net>
References: <1359673513-22328-1-git-send-email-bleung@chromium.org>
 <1360527340-25936-1-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360527340-25936-1-git-send-email-bleung@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 12:15:40PM -0800, Benson Leung wrote:
> This patch adds support for the Cypress APA Smbus Trackpad type,
> which uses a modified register map that fits within the
> limitations of the smbus protocol.
> 
> Devices that use this protocol include:
> CYTRA-116001-00 - Samsung Series 5 550 Chromebook trackpad
> CYTRA-103002-00 - Acer C7 Chromebook trackpad
> CYTRA-101003-00 - HP Pavilion 14 Chromebook trackpad
> 
> Signed-off-by: Dudley Du <dudl@cypress.com>
> Signed-off-by: Benson Leung <bleung@chromium.org>
> Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
> v2 : Minor style cleanup. Removed unused struct device *dev declarations.
> ---

Applied, thank you Benson.

Henrik, I put you down as "reviewed-by".

Thanks!

-- 
Dmitry
