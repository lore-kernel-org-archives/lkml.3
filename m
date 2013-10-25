Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3JYJ2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:28:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab3JYJ2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:28:15 -0400
Date: Fri, 25 Oct 2013 10:28:11 +0100 (BST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Anders_F=2E_U=2E_Ki=E6r?= <ablacksheep@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Added Holtek USB ID 04d9:a072 LEETGION Hellion
 Gaming Mouse 
In-Reply-To: <1382391742-31335-1-git-send-email-ablacksheep@gmail.com>
Message-ID: <alpine.LNX.2.00.1310251028010.30926@pobox.suse.cz>
References: <1382391742-31335-1-git-send-email-ablacksheep@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Oct 2013, Anders F. U. Kiær wrote:

>  Added id, bindings and comments for Holtek USB ID 04d9:a072
>  LEETGION Hellion Gaming mouse to use the same corrections of the report
>  descriptor as Holtek 04d9:a067. As the mouse exceed HID_MAX_USAGES at the
>  same offsets in the reported descriptor.
>  Tested on the hardware.
> 
> Signed-off-by: Anders F. U. Kiær <ablacksheep@gmail.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
