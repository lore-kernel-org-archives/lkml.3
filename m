Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab3ITJaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:30:12 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:47971 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202Ab3ITJaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:30:10 -0400
Date: Fri, 20 Sep 2013 10:30:01 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Roy Franz <roy.franz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 09/17] Move unicode to ASCII conversion to shared
 function.
Message-ID: <20130920093001.GE4785@console-pimps.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
 <1379391093-27948-10-git-send-email-roy.franz@linaro.org>
 <20130919034406.GA26385@angband.pl>
 <CAFECyb-tTaCEqUHUh23MaJf-P42ZpodFKeNG=kE+vmmi-gyKrw@mail.gmail.com>
 <20130919230241.GA18666@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919230241.GA18666@angband.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Sep, at 01:02:41AM, Adam Borowski wrote:
> Are we on the same page so far?  If so, I can make a patch atop yours.

Patches to fix this would be most welcome, though I'd wait until Roy
sends out another version of this patch with the name/comment changes.

This series will eventually end up in the 'next' branch at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

-- 
Matt Fleming, Intel Open Source Technology Center
