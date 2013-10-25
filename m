Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3JYXIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 19:08:55 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:50863 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3JYXIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 19:08:53 -0400
Date: Fri, 25 Oct 2013 16:08:50 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Manish Badarkhe <badarkhe.manish@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH] tps65090-charger: Use "IS_ENABLED(CONFIG_OF)" for DT
 code.
Message-ID: <20131025230850.GA9015@teo>
References: <1380342744-4227-1-git-send-email-badarkhe.manish@gmail.com>
 <5249A0DC.9030206@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5249A0DC.9030206@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 12:03:40PM -0400, Rhyland Klein wrote:
> On 9/28/2013 12:32 AM, Manish Badarkhe wrote:
> > Instead of "#if defined(CONFIG_OF)" use "IS_ENABLED(CONFIG_OF)" option
> > for DT code to avoid if-deffery in code.
> > Also, arranged header files in alphabetically.
> > 
> > Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
> > ---
> > :100644 100644 bdd7b9b... 8b9c406... M	drivers/power/tps65090-charger.c
> >  drivers/power/tps65090-charger.c |   19 +++++--------------
> >  1 file changed, 5 insertions(+), 14 deletions(-)
> LGTM
> Acked-by: Rhyland Klein <rklein@nvidia.com>

Applied, thanks!

Anton
