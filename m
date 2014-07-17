Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbaGQMuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:50:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56181 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043AbaGQMuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:50:54 -0400
Date: Thu, 17 Jul 2014 14:50:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: Fabian Frederick <fabf@skynet.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>
Subject: Re: [PATCH 1/1] drivers/edac/edac_module.c: remove unnecessary test
 on unsigned value
Message-ID: <20140717125049.GB22549@pd.tnic>
References: <1402341618-10674-1-git-send-email-fabf@skynet.be>
 <20140610182719.GA28752@pd.tnic>
 <CANZNk83PDVa56z9iomRbWQWoRCfrmzUpcMCTO1zUv5CtAOSaZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANZNk83PDVa56z9iomRbWQWoRCfrmzUpcMCTO1zUv5CtAOSaZQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 03:26:26PM +0300, Andrey Utkin wrote:
> This hasn't got into none of v3.16-rc5 release, repos "linux-stable"
> and "torvalds/linux".
> See https://bugzilla.kernel.org/show_bug.cgi?id=80431

It is queued for 3.17 and it won't get into stable because it doesn't
fit stable rules.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
