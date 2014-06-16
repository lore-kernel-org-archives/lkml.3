Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaFPLjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:39:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaFPLjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:39:03 -0400
Date: Mon, 16 Jun 2014 13:39:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jamie Lentin <jm@lentin.co.uk>
cc: Antonio Ospite <ao2@ao2.it>, Alexander Clouter <alex@digriz.org.uk>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Rename hid-lenovo-tpkbd to hid-lenovo, so we can
 add other keyboards
In-Reply-To: <1402864790-7478-2-git-send-email-jm@lentin.co.uk>
Message-ID: <alpine.LNX.2.00.1406161338370.1321@pobox.suse.cz>
References: <1402864790-7478-1-git-send-email-jm@lentin.co.uk> <1402864790-7478-2-git-send-email-jm@lentin.co.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jun 2014, Jamie Lentin wrote:

> Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
> ---
>  drivers/hid/Kconfig                              |  14 +-
>  drivers/hid/Makefile                             |   2 +-
>  drivers/hid/hid-core.c                           |   2 +-
>  drivers/hid/{hid-lenovo-tpkbd.c => hid-lenovo.c} | 233 +++++++++++++----------
>  4 files changed, 142 insertions(+), 109 deletions(-)
>  rename drivers/hid/{hid-lenovo-tpkbd.c => hid-lenovo.c} (59%)

Documentation/ABI/testing/sysfs-driver-hid-lenovo-tpkbd would also need 
to be updated.

-- 
Jiri Kosina
SUSE Labs
