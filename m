Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3KHNPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 08:15:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272Ab3KHNPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 08:15:02 -0500
Date: Fri, 8 Nov 2013 14:14:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>,
        =?ISO-8859-15?Q?Michal_Mal=FD?= <madcatxster@prifuk.cz>
Subject: Re: [PATCH 1/5] HID:hid-lg4ff: Scale autocentering force properly
 on Logitech wheel
In-Reply-To: <1383766244-2336-1-git-send-email-simon@mungewell.org>
Message-ID: <alpine.LNX.2.00.1311081414470.835@pobox.suse.cz>
References: <1383766244-2336-1-git-send-email-simon@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, Simon Wood wrote:

> Adjust the scaling and lineartity to match that of the Windows
> driver (from MOMO testing).
> 
> Reported-by: Elias Vanderstuyft <elias.vds@gmail.com>
> Signed-off-by: Simon Wood <simon@mungewell.org>

I have applied the series, thanks.

-- 
Jiri Kosina
SUSE Labs
