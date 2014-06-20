Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbaFTUEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:04:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50706 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbaFTUEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:04:07 -0400
Date: Fri, 20 Jun 2014 22:03:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, mattieu.souchaud@free.fr
Subject: Re: [PATCH] x86/mce: Don't unregister CPU hotplug notifier in error
 path
Message-ID: <20140620200358.GK11391@pd.tnic>
References: <1403274493-1371-1-git-send-email-boris.ostrovsky@oracle.com>
 <20140620152312.GB11391@pd.tnic>
 <53A45627.6090306@oracle.com>
 <20140620155845.GC11391@pd.tnic>
 <53A45E67.7070000@oracle.com>
 <20140620175240.GE11391@pd.tnic>
 <53A48DF6.9020503@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53A48DF6.9020503@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 03:39:34PM -0400, Boris Ostrovsky wrote:
> What about mce_device_add()?

What is a mce_device_add()? There's no such function.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
