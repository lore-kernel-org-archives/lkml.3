Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaLaQ4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 11:56:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46035 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaLaQ4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 11:56:46 -0500
Date: Wed, 31 Dec 2014 17:56:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] x86: tools: shell-ify calc_run_size perl-ism
Message-ID: <20141231165642.GA7677@pd.tnic>
References: <20141231164302.GA1840@dhcppc1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141231164302.GA1840@dhcppc1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 05:43:02PM +0100, Sylvain BERTRAND wrote:
> Choked while compiling linux on a lightweight system, i.e. freed from perl.
> 
> New script tested with dash shell and bash shell.
> 
> V2:
> 	- chocked->choked typo
> 	- early conversion from hexadecimal
> 	- error messages on stderr

Your patches have the same subject. Instead, each subject should
describe what each patch is doing. Read Documentation/SubmittingPatches
for more info.

Also, do not rush in sending a new version in a day or so but wait a
couple of days to give people a chance to take a look and so that you
can collect all feedback.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
