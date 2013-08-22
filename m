Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab3HVLSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:18:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54304 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab3HVLSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:18:22 -0400
Date: Thu, 22 Aug 2013 13:17:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joonas Saarinen <jonskunator@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AMD Bobcat cpufreq
Message-ID: <20130822111753.GA17491@nazgul.tnic>
References: <5213CA4F.1070202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5213CA4F.1070202@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:58:07PM +0300, Joonas Saarinen wrote:
> Hi guys,
> 
> The turbo core feature on AMD Bobcat platform seems not to be
> working. I have a netbook with C-60 CPU which never cranks the
> frequency over 1000MHz (it could reach 1333MHz).

Yeah, how about more info like which kernel, /proc/cpuinfo, full dmesg,
dmidecode... sounds like enough for starters.

Thanks.
