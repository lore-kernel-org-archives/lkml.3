Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaBTQN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:13:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38836 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbaBTQNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:13:54 -0500
Date: Thu, 20 Feb 2014 17:13:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EDAC, MCE, AMD: Fix code to prevent NULL dereference
Message-ID: <20140220161351.GA2014@pd.tnic>
References: <1392659391-2411-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20140217182729.GE4559@pd.tnic>
 <5302625C.4050700@amd.com>
 <20140217194153.GG4559@pd.tnic>
 <53028EE8.20106@amd.com>
 <20140218003654.GK4559@pd.tnic>
 <20140218084636.GA24465@pd.tnic>
 <5303A607.7090309@amd.com>
 <20140220093207.GB8876@pd.tnic>
 <53062845.8010203@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53062845.8010203@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 10:07:33AM -0600, Aravind Gopalakrishnan wrote:
> Tested the above a final time on local machine and it works fine..

Ok, I'll queue it up with your Tested-by. Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
