Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3LQTGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:06:19 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36144 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab3LQTGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:06:16 -0500
Date: Tue, 17 Dec 2013 20:06:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers: ide: Include appropriate header file in
 ide-cd_verbose.c
Message-ID: <20131217190610.GJ30592@pd.tnic>
References: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com>
 <20131217111920.GA30592@pd.tnic>
 <20131217164403.GD1062@leaf>
 <20131217175451.GI30592@pd.tnic>
 <52B0A93E.7090503@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52B0A93E.7090503@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 10:42:54PM +0300, Sergei Shtylyov wrote:
> You're right in your doubting: there are quite a lot of drivers used
> by embedded platforms that nobody has bothered to convert to libata
> thus far.

Hold on, what does that mean? IDE is back from the dead and used only
for embedded stuff?

Or we force people to convert drivers to libata by *deleting* ide?

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
