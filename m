Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaAUQO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:14:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44932 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbaAUQOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:14:54 -0500
Date: Tue, 21 Jan 2014 17:14:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: AMD microcode loading broken on 32 bit
Message-ID: <20140121161438.GD9004@pd.tnic>
References: <52DE94A9.9060505@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52DE94A9.9060505@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 10:39:21AM -0500, Boris Ostrovsky wrote:
> I was thinking this could have been introduced by last night's merge
> of your tree.

Ok, I need more info:

* kernel .config

* are you building an initrd with the microcode? If so, how exactly?
Which microcode blob?

* what machine, family?

* anything else I'd need to reproduce here?

Btw, why the h*ll are you still using a 32-bit kernel? :)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
