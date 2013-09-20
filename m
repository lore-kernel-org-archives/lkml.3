Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab3ITJ1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:27:23 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:59176 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754215Ab3ITJ1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:27:21 -0400
Date: Fri, 20 Sep 2013 10:27:13 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: Adam Borowski <kilobyte@angband.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 09/17] Move unicode to ASCII conversion to shared
 function.
Message-ID: <20130920092713.GD4785@console-pimps.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
 <1379391093-27948-10-git-send-email-roy.franz@linaro.org>
 <20130919034406.GA26385@angband.pl>
 <CAFECyb-tTaCEqUHUh23MaJf-P42ZpodFKeNG=kE+vmmi-gyKrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFECyb-tTaCEqUHUh23MaJf-P42ZpodFKeNG=kE+vmmi-gyKrw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Sep, at 09:48:44PM, Roy Franz wrote:
> Would it be acceptable to fix the naming/comments, and convert values
> above 126 to '?'
> in the current patchset, and address a more thorough fix in another patch set?
> The ARM and ARM64 EFI stub patchsets that are mostly complete depend
> on this one,
> so getting this merged soon would be helpful.

Just fixing the function name and comments is enough for this patch
series. Anything else should be separate.

-- 
Matt Fleming, Intel Open Source Technology Center
